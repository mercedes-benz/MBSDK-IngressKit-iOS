//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBIngressKit

// MARK: - BffProvider

final public class BffProvider {

	static var providerSessionId: String = UUID().uuidString
	private var sdkVersion: String


	// MARK: - Init

	public init(sdkVersion: String) {

		guard sdkVersion.isEmpty == false else {
			fatalError("no sdk version available")
		}

		self.sdkVersion = sdkVersion
	}
}

extension BffProvider: BffProviding {

	public var headerParamProvider: HeaderParamProviding {
		return HeaderParamProvider(sdkVersion: self.sdkVersion)
	}

	/// session id for bff
	public var sessionId: String {
		get {
			return BffProvider.providerSessionId
		}
		set {
			BffProvider.providerSessionId = newValue
		}
	}

	public var urlProvider: UrlProviding {
		return BffUrlProvider()
	}
}

// MARK: - BffUrlProvider

final class BffUrlProvider {

	init() {}
}

extension BffUrlProvider: UrlProviding {

	var baseUrl: String {
		return "https://bff-\(StageHelper.urlStageString).risingstars\(StageHelper.urlRegionString).daimler.com/v1"
	}
}


// MARK: - HeaderParam

struct HeaderParamKey {
	static let authorization 		= "Authorization"
	static let sdkVersion			= "RIS-SDK-Version"
	static let operatingName	    = "RIS-OS-Name"
	static let operatingVersion		= "RIS-OS-Version"
	static let locale				= "X-Locale"
	static let sessionId 			= "X-SessionId"
	static let trackingId 			= "X-TrackingId"
	static let countryCode 			= "X-MarketCountryCode"
	static let applicationName      = "X-ApplicationName"
	static let applicationVersion   = "X-ApplicationVersion"
    static let ldssoAppId           = "ldsso-AppId"
    static let ldssoAppVersion      = "ldsso-AppVersion"
}


// MARK: - HeaderParamProvider

final public class HeaderParamProvider {

	private var sdkVersion: String


	// MARK: - Init

	init(sdkVersion: String) {
		self.sdkVersion = sdkVersion
	}
}

extension HeaderParamProvider: HeaderParamProviding {
    
	public var authorizationHeaderParamKey: String {
		return HeaderParamKey.authorization
	}

	public var countryCodeHeaderParamKey: String {
		return HeaderParamKey.countryCode
	}

	public var defaultHeaderParams: [String: String] {
		return [
			HeaderParamKey.sessionId: BffProvider.providerSessionId,
			HeaderParamKey.trackingId: UUID().uuidString,
			HeaderParamKey.applicationName: "IngressKit",
			HeaderParamKey.sdkVersion: self.sdkVersion,
			HeaderParamKey.locale: IngressKit.localeIdentifier,
			HeaderParamKey.operatingName: "ios",
			HeaderParamKey.applicationVersion: "\(Bundle.main.shortVersion) (\(Bundle.main.buildVersion))"
		]
	}

	public var localeHeaderParamKey: String {
		return HeaderParamKey.locale
	}
    
    public var ldssoAppHeaderParams: [String: String] {
        return [
            HeaderParamKey.ldssoAppId: "1716",
            HeaderParamKey.ldssoAppVersion: "1716_4315"
        ]
    }
}


// MARK: - KeycloakProviding

final public class KeycloakProvider {

	// MARK: - Init

	public init() {}
}


extension KeycloakProvider: KeycloakProviding {
	
	public var clientId: String {
		return ""
	}

	public var stageName: String {

		guard let stage = StageHelper.appDelegate?.stageEndpoint else {
			return ""
		}

		switch stage {
		case .ci,
			 .int,
			 .mock: 	return "int"
		case .prod:     return "prod"
		}
	}

	public var urlProvider: UrlProviding {
		return KeycloackUrlProvider()
	}
}


// MARK: - KeycloackUrlProvider

final class KeycloackUrlProvider {

	init() {}
}

extension KeycloackUrlProvider: UrlProviding {

	var baseUrl: String {
		return "https://keycloak.risingstars\(StageHelper.urlRegionString).daimler.com/auth/realms/Daimler"
	}
}


// MARK: - StageHelper

private struct StageHelper {

	static var appDelegate: AppDelegate? {
		return UIApplication.shared.delegate as? AppDelegate
	}

	static var urlRegionString: String {

		let prefix: String = {
			guard let stage = self.appDelegate?.stageEndpoint,
				stage != .prod else {
					return ""
			}

			return "-int"
		}()

		guard let region = self.appDelegate?.stageRegion,
			region != .ece else {

				guard let stage = self.appDelegate?.stageEndpoint,
					stage != .mock else {
						return "-mock"
				}
				return prefix
		}

		return prefix + "-" + region.rawValue
	}

	static var urlStageString: String {
		return self.appDelegate?.stageEndpoint.rawValue ?? ""
	}

}
