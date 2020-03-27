//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct KeycloackParamKey {
    
    static let appId = "app-id"
    static let clientId = "client_id"
    static let grantType = "grant_type"
    static let refreshToken = "refresh_token"
    static let username = "username"
    static let password = "password"
    static let scope = "scope"
}

struct KeycloackParamValue {
    
    static let password = "password"
    static let refreshToken = "refresh_token"
    static let offlineAccess = "offline_access"
}
