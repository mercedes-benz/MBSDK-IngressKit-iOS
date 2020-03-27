//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

class NativeLoginService {
	
	// MARK: Typealias
	internal typealias LoginAPIResult = NetworkResult<APILoginModel>
	
	// MARK: Properties
	private var internalToken: Token?
	private var token: Token? {
		get {
			return self.internalToken
//			return KeychainHelper.token
		}
		set {
			let newToken: Token = {
				guard let newValue = newValue else {
					LOG.E("Set a not valid token")
					return Token(accessToken: "", expirationDate: nil, refreshToken: "", sessionState: "", tokenType: .native)
				}
				return newValue
			}()
			
			KeychainHelper.token = newToken
			self.internalToken   = newToken
		}
	}
	private var username: String
	private var pin: String
	
	
	// MARK: - Init
	
	init(username: String, pin: String) {
		
		self.internalToken = KeychainHelper.token
		self.username      = username
		self.pin           = pin
	}
	
	
	// MARK: - Helper
	
	private func requestLogout(router: KeycloakEndpointRouter, completion: @escaping LoginService.LoginServiceResult) {
		
		NetworkLayer.requestData(router: router) { (response) in
			
			switch response {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				let error = MBError(description: error.localizedDescription, type: .unknown)
				completion(.failure(error))
				
			case .success:
				LOG.E("Logout request succeeded and set token as nil")
				self.token = nil
				completion(.success)
			}
		}
	}
	
	private func requestToken(router: KeycloakEndpointRouter, completion: @escaping LoginService.LoginServiceResult) {
		
		NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APILoginModel>) in
			
			switch result {
			case .failure(let error):
				let errorDecodable = NetworkLayer.errorDecodable(error: error, parsingType: APIErrorKeycloakModel.self)
				LOG.E(router)
				LOG.E(errorDecodable.localizedDescription)
				LOG.E(error.localizedDescription)
				
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success(let value):
				LOG.D(value)
				self.token = NetworkModelMapper.map(apiLogin: value)
				completion(.success)
			}
		}
	}
}


// MARK: - JwtTokenService

extension NativeLoginService: JwtTokenService {}


// MARK: - LoginServiceProtocol

extension NativeLoginService: LoginServiceProtocol {
	
	func login(completion: @escaping LoginService.LoginServiceResult) {
		
		LOG.D("Will start login request")
		let router = KeycloakEndpointRouter.login(username: self.username, pin: self.pin)
		self.requestToken(router: router) { [weak self] (result) in
			
			switch result {
			case .failure:
				LOG.D("Reset login token, because request failed")
				self?.token = nil
				
			case .success:
				break
			}
			completion(result)
		}
	}

	func logout(completion: @escaping LoginService.LoginServiceResult) {
		
        guard let token = self.token else {
			let error = MBError(description: LoginError.notAuthorized.localizedDescription, type: .unknown)
            completion(.failure(error))
            return
        }
        
		let router = KeycloakEndpointRouter.logout(token: token.refreshToken)
		self.requestLogout(router: router, completion: completion)
	}
	
	func refreshTokenIfNeeded(retrierCount: Int, completion: @escaping TokenResult) {
		
		guard let token = self.token else {
			let error = MBError(description: LoginError.notAuthorized.localizedDescription, type: .unknown)
			completion(.failure(error))
			return
		}
		
		let expiredAt = token.accessExpirationDate.addingTimeInterval(-60)
		
		guard Date().compare(expiredAt) != .orderedAscending else {
			completion(.success(token))
			return
		}
		
		let router = KeycloakEndpointRouter.refresh(token: token.refreshToken)
		LOG.D("start token request with: \(token.refreshType) - \(token.refreshToken)")
		self.requestToken(router: router) { [weak self] (result) in
			
			switch result {
			case .failure(let error):
				if retrierCount > 1 {
					
					LOG.D("retrier token refresh")
					let newRetryCount = max(1, (retrierCount - 1))
					self?.refreshTokenIfNeeded(retrierCount: newRetryCount, completion: completion)
				} else {
					LOG.E("Refresh token request failed")
					completion(.failure(error))
				}
				
			case .success:
				guard let token = self?.token else {
					LOG.E("Refresh token request succeeded, but save the JWT failed")
					return
				}
				completion(.success(token))
			}
		}
	}
}
