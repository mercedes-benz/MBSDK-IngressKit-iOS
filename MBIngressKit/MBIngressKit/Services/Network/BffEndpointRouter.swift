//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffEndpointRouter: EndpointRouter {
    case assistancemail(dict: [String: Any]?)
	case countries
	case profileFields(countryCode: String, locale: String)
    
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
        case .assistancemail,
             .countries:
            break

        case .profileFields(_, let locale):
            headers[headerParamProvider.localeHeaderParamKey] = locale
        }
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .assistancemail:                   return .post
		case .countries:					    return .get
		case .profileFields:                    return .get
		}
	}
	var path: String {
		switch self {
		case .assistancemail:                   return "assistancemail"
		case .countries:        			    return "countries"
		case .profileFields:                    return "profile/fields"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .assistancemail(let dict):
			return dict
	
		case .profileFields(let countryCode, _):
			return ["countryCode": countryCode]
			
		case .countries:
			return nil
		}
	}
	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .assistancemail:                   return .json
		case .countries:					    return .url(type: .standard)
		case .profileFields:                    return .url(type: .standard)
        }
	}
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	var bodyParameters: [String: Any]? {
		switch self {
		case .assistancemail(let dict):                     return dict
		case .countries:								    return nil
		case .profileFields:                                return nil
		}
	}
	var bodyEncoding: ParameterEncodingType {
		return self.parameterEncoding
	}
	var timeout: TimeInterval {
		return IngressKit.bffProvider?.urlProvider.requestTimeout ?? IngressKit.defaultRequestTimeout
	}
}
