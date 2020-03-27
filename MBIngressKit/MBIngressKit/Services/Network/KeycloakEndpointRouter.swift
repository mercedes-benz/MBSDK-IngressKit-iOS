//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBCommonKit
import MBNetworkKit

enum KeycloakEndpointRouter: EndpointRouter {
	case login(username: String, pin: String)
    case logout(token: String)
	case refresh(token: String)
	
	
	// MARK: Properties
	var baseURL: String {
		guard let urlProvider = IngressKit.keycloackProvider?.urlProvider else {
			fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
		}
		return urlProvider.baseUrl
	}
    
	var httpHeaders: [String: String]? {
		
		guard let keycloackProvider = IngressKit.keycloackProvider else {
			fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
		}

        var headers = [
            "Stage": keycloackProvider.stageName
        ]
		
		switch self {
		case .login:
			headers["device-uuid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
			return headers
			
		case .logout,
			 .refresh:
			return headers
        }
	}
    
	var method: HTTPMethodType {
		switch self {
		case .login:	return .post
		case .logout:	return .get
		case .refresh:	return .post
		}
	}
    
	var path: String {
		switch self {
		case .login:	return "/protocol/openid-connect/token"
		case .logout:	return "/protocol/openid-connect/logout"
		case .refresh:	return "/protocol/openid-connect/token"
		}
	}
    
	var parameters: [String: Any]? {
		switch self {
		case .login(let username, let pin):
			return [
				KeycloackParamKey.clientId: IngressKit.keycloackProvider?.clientId ?? "",
				KeycloackParamKey.grantType: KeycloackParamValue.password,
                KeycloackParamKey.scope: KeycloackParamValue.offlineAccess,
				KeycloackParamKey.username: username,
				KeycloackParamKey.password: pin
			]
			
		case .logout(let token):
            return [
				KeycloackParamKey.refreshToken: token
			]
			
		case .refresh(let token):
			return [
				KeycloackParamKey.clientId: IngressKit.keycloackProvider?.clientId ?? "",
				KeycloackParamKey.grantType: KeycloackParamValue.refreshToken,
				KeycloackParamKey.refreshToken: token
			]
		}
	}
    
	var parameterEncoding: ParameterEncodingType {
		return .url(type: .standard)
	}
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
    
	var timeout: TimeInterval {
		return IngressKit.bffProvider?.urlProvider.requestTimeout ?? IngressKit.defaultRequestTimeout
	}
}
