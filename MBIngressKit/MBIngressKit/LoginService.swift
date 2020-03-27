//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

/// Fascade service to call login requests
///
/// Handles native and appAuth logins
public class LoginService {
	
	// MARK: Typealias
    
    /// Completion for login-request
    ///
    /// Returns NonValueResult with error or success
	public typealias LoginServiceResult = (EmptyResult) -> Void
	
    /// Completion for refreshToken request
    ///
    /// Returns token object
    public typealias OnCompleteToken = (Token) -> Void
	
    /// Error completion for refreshToken-request
    ///
    /// Returns error-object
    public typealias OnError = (MBError) -> Void
	
	private var loginService: LoginServiceProtocol?
	private var logoutCompletion: LoginServiceResult?
	
	/// Observable for refresh token handling
	private var refreshTokenObservables: [(onComplete: OnCompleteToken, onError: OnError)] = []
	private var refreshTokenState: RefreshTokenState = .finished {
		didSet {
			switch self.refreshTokenState {
			case .error(let error):
				while let tokenObservable = self.refreshTokenObservables.popLast() {
					tokenObservable.onError(error)
				}
				self.refreshTokenState = .finished
				
			case .finished:
				break
				
			case .new(let token):
				while let tokenObservable = self.refreshTokenObservables.popLast() {
					tokenObservable.onComplete(token)
				}
				self.refreshTokenState = .finished
				
			case .started(let retrierCount):
				self.requestTokenRefresh(retrierCount: retrierCount)
			}
		}
	}
	private var timer: Timer?
	
    /// Get current tokenState
    ///
    /// Get only
	public var tokenState: TokenState {
		
		guard let token = self.token else {
			return .loggedOut
		}
		
		if token.isAuthorized == false {
			return .loggedOut
		}
		
		if token.isAccessTokenExpired == false {
			return .authorized
		}
		
		return token.isRefreshTokenExpired ? .loggedOut : .loggedIn
	}
	
    
    /// Get current token-object (optional)
    ///
    /// Get only
	public var token: Token? {
		return KeychainHelper.token
	}

	
	// MARK: - Public
    
    /// Start login request with user credentials
    ///
    /// - Parameters:
    ///   - username: email or phonenumber
    ///   - pin: pin from verification mail/sms
    ///   - completion: LoginServiceResult completion closure
	public func login(username: String, pin: String, completion: @escaping LoginServiceResult) {
		
		self.loginService = NativeLoginService(username: username, pin: pin)
		self.loginService?.login(completion: completion)
	}
	
    
    /// Logout the user
    ///
    /// - Parameters completion: LoginServiceResult completion closure
    ///     - success: User is successfully logged out
    ///     - error: ResponseError object
	public func logout(completion: @escaping LoginServiceResult) {
		
		guard let loginService = self.getLoginService() else {
			let error = MBError(description: LoginError.noEnviroment.localizedDescription, type: .unknown)
			completion(.failure(error))
			return
		}
		
		self.logoutCompletion = completion
		loginService.logout { (result) in
            
			KeychainHelper.token = nil
            IngressKit.userService.logout()
			completion(result)
            
            // login service and its properties (e.g. username) are no
            // longer valid and required after logout
            self.loginService = nil
		}
	}
	
    
    /// Refresh the accessToken in case it's expired
    ///
    /// - Parameters:
    ///   - retrierCount: set how often the retry should be processed. default == 1
    ///   - onComplete: OnCompleteToken completion closure
    ///   - onError: OnError completion closure
	public func refreshTokenIfNeeded(retrierCount: Int = 1, onComplete: @escaping OnCompleteToken, onError: @escaping OnError) {
		
		let observableTupel = (onComplete: onComplete, onError: onError)
		self.refreshTokenObservables.append(observableTupel)
		
		switch self.refreshTokenState {
		case .error:	break
		case .finished:	self.guardProtected(retrierCount: 6, requestRetryCount: retrierCount) //self.refreshTokenState = .started(retrierCount: retrierCount)
		case .new:		break
		case .started:	break
		}
	}
	
	
	// MARK: - Helper
	
	private func getLoginService() -> LoginServiceProtocol? {
		
		guard let loginService = self.loginService else {
			guard let token = self.token else {
				return nil
			}
			
			switch token.tokenType {
			case .appAuth:	return nil
			case .native:	return NativeLoginService(username: "", pin: "")
			}
		}
		
		return loginService
	}
	
	private func guardProtected(retrierCount: Int, requestRetryCount: Int) {
		
		if self.token != nil || retrierCount <= 1 {
			self.refreshTokenState = .started(retrierCount: requestRetryCount)
		} else if self.timer == nil || self.timer?.isValid == false {
			
			self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] (timer) in
				
				timer.invalidate()
				let newRetryCount = max(1, (retrierCount - 1))
				LOG.D("retrier token access: \(retrierCount) -> \(newRetryCount)")
				self?.guardProtected(retrierCount: newRetryCount, requestRetryCount: requestRetryCount)
			}
		}
	}
	
	private func requestTokenRefresh(retrierCount: Int) {
		
		guard let loginService = self.getLoginService() else {
			LOG.E("Empty login service and set token state to error")
			
			let error = MBError(description: LoginError.noValidJwtToken.localizedDescription, type: .unknown)
			self.refreshTokenState = .error(error: error)
			return
		}
		
		loginService.refreshTokenIfNeeded(retrierCount: retrierCount) { (result) in
			
			switch result {
			case .failure(let error):	self.refreshTokenState = .error(error: error)
			case .success(let token):	self.refreshTokenState = .new(token: token)
			}
		}
	}
}
