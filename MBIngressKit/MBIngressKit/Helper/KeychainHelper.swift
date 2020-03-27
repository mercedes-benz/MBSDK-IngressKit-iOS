//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct KeychainHelper {
	
	// MARK: - Keys
	
	private struct Keys {
		static let jwtTokenKey = "jwtTokenKey"
		static let service = "RISAppfamily"
	}
	
	// MARK: - Properties
	
	/// jwt
	static var token: Token? {
		get {
			guard let data = self.keychainWrapper.object(forKey: Keys.jwtTokenKey) as? Data else {
				LOG.E("Return empty (nullable) JWT from keychain")
				return nil
			}
			
			return try? JSONDecoder().decode(Token.self, from: data)
		}
		set {
			guard let newToken = newValue,
				let encodeToken = try? JSONEncoder().encode(newToken) else {
					self.keychainWrapper.removeObject(forKey: Keys.jwtTokenKey)
					LOG.E("Removing JWT from keychain, because setter is nil")
					return
				}
			
			let data = NSKeyedArchiver.archivedData(withRootObject: encodeToken)
			let saved = self.keychainWrapper.set(data, forKey: Keys.jwtTokenKey)
			if saved == false {
				LOG.E("Saving JWT to keychain failed")
			} else {
				LOG.E("Saving JWT to keychain succeeded")
			}
		}
	}

	
	// MARK: - Helper
	
	private static var keychainWrapper: KeychainWrapper {
		return KeychainWrapper(serviceName: Keys.service)
	}
}
