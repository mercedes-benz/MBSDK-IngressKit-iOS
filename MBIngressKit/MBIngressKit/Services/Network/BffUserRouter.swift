//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffUserRouter: EndpointRouter {
    case adaptionValues(accessToken: String, dict: [String: Any]?)
	case biometric(accessToken: String, dict: [String: Any]?)
    case create(countryCode: String, locale: String, dict: [String: Any]?)
	case delete(accessToken: String)
	case exist(dict: [String: Any]?)
	case get(accessToken: String)
	case update(accessToken: String, dict: [String: Any]?)
	case updateUnitPreferences(accessToken: String, dict: [String: Any]?)
    case verification(accessToken: String, scanReference: String)
    
	// MARK: Properties
	var baseURL: String {
		guard let urlProvider = IngressKit.bffProvider?.urlProvider else {
			fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
		}
		return urlProvider.baseUrl
	}
	var httpHeaders: [String: String]? {
		
		guard let headerParamProvider = IngressKit.bffProvider?.headerParamProvider else {
			fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
		}

		var headers = headerParamProvider.defaultHeaderParams
        
        switch self {
        case .adaptionValues(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
            headers[headerParamProvider.countryCodeHeaderParamKey] = IngressKit.countryCode
		
        case .biometric(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
			
        case .create(let countryCode, let locale, _):
            headers[headerParamProvider.countryCodeHeaderParamKey] = countryCode
            headers[headerParamProvider.localeHeaderParamKey] = locale
            
        case .delete(let accessToken):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
            headers[headerParamProvider.countryCodeHeaderParamKey] = IngressKit.countryCode
		
        case .exist:
			break
			
        case .get(let accessToken):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
			
        case .update(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
            headers[headerParamProvider.countryCodeHeaderParamKey] = IngressKit.countryCode
            
        case .updateUnitPreferences(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
            
        case .verification(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
        }
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .adaptionValues:			return .put
		case .biometric:				return .post
		case .create:					return .post
		case .delete:					return .delete
		case .exist:					return .post
		case .get:						return .get
		case .update:					return .put
		case .updateUnitPreferences:	return .put
		case .verification:				return .post
		}
	}
	var path: String {
		let ciamId = "self"
		switch self {
		case .adaptionValues:			return "/user/adaptionValues"
		case .biometric:				return "/user/biometric"
		case .create:					return "user"
		case .delete:					return "user/\(ciamId)"
		case .exist:					return "login"
		case .get:						return "user/\(ciamId)"
		case .update:					return "user/\(ciamId)"
		case .updateUnitPreferences:	return "user/unitpreferences"
		case .verification:				return "user/verification"
		}
	}
	var parameters: [String: Any]? {
		return nil
	}
	var parameterEncoding: ParameterEncodingType {
		return .json
	}
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	var bodyParameters: [String: Any]? {
		switch self {
		case .adaptionValues(_, let dict):		    	return dict
		case .biometric(_, let dict):					return dict
		case .create(_, _, let dict):					return dict
		case .delete:								    return nil
		case .exist(let dict):						    return dict
		case .get:									    return nil
		case .update(_, let dict):					    return dict
		case .updateUnitPreferences(_, let dict):	    return dict
		case .verification(_, let scanReference):		return ["scanReference": scanReference]
		}
	}
	var bodyEncoding: ParameterEncodingType {
		return self.parameterEncoding
	}
	var timeout: TimeInterval {
		return IngressKit.bffProvider?.urlProvider.requestTimeout ?? IngressKit.defaultRequestTimeout
	}
}
