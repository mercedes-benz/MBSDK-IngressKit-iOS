//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum JwtEndpointRouter: EndpointRouter {
	case jwt(accessToken: String)
	
	// MARK: Properties
	var baseURL: String {
		return ""
	}
	var httpHeaders: [String: String]? {
        
        guard let headerParamProvider  = IngressKit.bffProvider?.headerParamProvider else {
            fatalError("headerParamProvider not available")
        }
        
		switch self {
		case .jwt(let accessToken):
			return [headerParamProvider.authorizationHeaderParamKey: "Bearer \(accessToken)"]
		}
	}
	var method: HTTPMethodType {
		switch self {
		case .jwt:
			return .get
		}
	}
	var path: String {
		switch self {
		case .jwt:
			return "getToken"
		}
	}
	var parameters: [String: Any]? {
		return nil
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
