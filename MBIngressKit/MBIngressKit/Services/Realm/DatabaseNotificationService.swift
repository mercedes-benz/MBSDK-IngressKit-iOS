//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBRealmKit
import RealmSwift

class DatabaseNotificationService {
	
	// MARK: Struct
	private struct Token {
		static let users = "users"
	}
	
	// MARK: Lazy
	private lazy var tokenName: String = {
		return String(describing: self)
	}()
	
	
	// MARK: - Init
	
	init() {
		self.observeUsers()
	}
	
	
	// MARK: - Object life cycle
	
	deinit {
		LOG.V()
		
		RealmToken.invalide(for: self.tokenName + Token.users)
	}
	
	
	// MARK: - Helper
	
	private func observeUsers() {
		
		let token = DatabaseUserService.fetch(initial: { [weak self] (provider) in
			self?.didChangeUsers(with: provider, isNewUser: true)
		}, update: { [weak self] (provider, _, insertions, _) in
			self?.didChangeUsers(with: provider, isNewUser: insertions.isEmpty == false)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.users)
	}
	
	private func didChangeUsers(with provider: ResultsUserProvider, isNewUser: Bool) {
		
		guard provider.isEmpty == false else {
			return
		}
		
		guard let ciamId = IngressKit.loginService.token?.ciamId,
			let user = provider.map(ciamId: ciamId) else {
				return
		}
		
		let userInfo: [String: Bool] = [
			"isNewUser": isNewUser
		]
		
		NotificationCenter.default.post(name: NSNotification.Name.didUpdateUser,
										object: user,
										userInfo: userInfo)
	}
}
