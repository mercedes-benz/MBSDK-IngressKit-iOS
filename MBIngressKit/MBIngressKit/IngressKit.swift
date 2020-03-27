//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

let LOG = MBLogger.shared

/// Main part of the MBIngressKit-module
///
/// Fascade to communicate with all provided services
public class IngressKit {
	
	// MARK: Properties
	private static let shared = IngressKit()
	private let serviceLogin: LoginService
	private let serviceUser: UserService
	
	static var defaultRequestTimeout: TimeInterval = 10
	
	
	// MARK: - Public
	
	/// Access to login services
	public static var loginService: LoginService {
		return self.shared.serviceLogin
	}
    
	/// Access to user services
	public static var userService: UserService {
		return self.shared.serviceUser
	}

	/// CountryCode
    public static var countryCode: String {
        return self.userService.validUser?.accountCountryCode ?? Locale.current.regionCode ?? ""
    }
	
	/// Locale identifier
    public static var localeIdentifier: String {
		
		let defaultLocale: String = {
			guard let languageCode = Locale.current.languageCode,
				let regionCode = Locale.current.regionCode else {
					return ""
			}
			return languageCode + "-" + regionCode
		}()
		
		return self.userService.validUser?.preferredLanguageCode ?? defaultLocale
    }
	
    /// Returns the bff provider
    public static var bffProvider: BffProviding?
	
	/// Returns the keycloak provider
	public static var keycloackProvider: KeycloakProviding?
	
	private var databaseNotificationService: DatabaseNotificationService
	
	
	// MARK: - Initializer
	
	private init() {
		
		self.databaseNotificationService = DatabaseNotificationService()
		
		self.serviceLogin = LoginService()
		self.serviceUser  = UserService()
	}
}
