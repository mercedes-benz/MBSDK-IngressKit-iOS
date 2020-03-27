//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import JWTDecode
import MBCommonKit

/// Representation of abstract layer of the jwt
public struct Token: Codable, TokenConformable {
	
	public let accessToken: String
	public let expirationDate: Date?
	public let refreshToken: String
	let sessionState: String
	let tokenType: TokenType
}


// MARK: - Extension

extension Token {
	
	/// Expiration date of access token
	public var accessExpirationDate: Date {
		return self.accessTokenDecode?.expiresAt ?? Date()
	}
	
	var accessTokenDecode: JWT? {
		return try? decode(jwt: self.accessToken)
	}
	
	/// Included ciam identifier from the token
	public var ciamId: String? {
		return self.accessTokenDecode?.claim(name: "ciamid").string
	}
	
	var isAccessTokenExpired: Bool {
		return self.accessTokenDecode?.expired == true
	}
	
	var isAccessTokenValid: Bool {
		return self.accessToken.isEmpty == false &&
			self.accessTokenDecode != nil
	}
	
	var isAuthorized: Bool {
		return self.isAccessTokenValid &&
			self.isRefreshTokenValid
	}
	
	var isExpired: Bool {
		return self.isAccessTokenExpired &&
			self.isRefreshTokenExpired
	}
	
	var isRefreshTokenExpired: Bool {
        return self.refreshType == .refresh ?
            self.refreshTokenDecode?.expired == true :
			false // Refresh Tokens of type 'offline' never expires from the client's perspective
	}
	
	var isRefreshTokenValid: Bool {
		return self.refreshToken.isEmpty == false &&
			self.refreshTokenDecode != nil
	}
	
	/// Preferred user name (mail or phone number)
	public var preferredUsername: String? {
		return self.accessTokenDecode?.claim(name: "preferred_username").string
	}
	
	/// Expiration date of refresh token
	public var refreshExpirationDate: Date? {
		return self.refreshTokenDecode?.expiresAt
	}
    
    /// Type  of refresh token (typically 'Refresh' for common refresh tokens or 'Offline' for Offline-Access tokens)
    public var refreshType: RefreshTokenType {
		return self.refreshTokenDecode?.claim(name: "typ").string?.caseInsensitiveCompare(RefreshTokenType.offline.rawValue) == .orderedSame ? .offline : .refresh
    }
    
	var refreshTokenDecode: JWT? {
		return try? decode(jwt: self.refreshToken)
	}
}
