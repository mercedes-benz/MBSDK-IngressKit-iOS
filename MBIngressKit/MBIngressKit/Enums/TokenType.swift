//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Type of the authorization token
public enum TokenType: String, Codable {
	case appAuth
	case native = "Bearer"
}
