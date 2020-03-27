//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of country
public struct CountryModel: Codable {
    
    public let availability: Bool
    public let countryCode: String
    public let countryName: String
    public let instance: String
    public let legalRegion: String
    public let locales: [CountryLocaleModel]
    public let natconCountry: Bool
}


// MARK: - Extension

public extension CountryModel {
	
	var isNatConCountry: Bool {
		return self.natconCountry
	}
}
