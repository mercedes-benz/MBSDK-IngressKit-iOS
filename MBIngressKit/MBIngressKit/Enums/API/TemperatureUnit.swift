//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for temperature unit
public enum TemperatureUnit: String, Codable {
	case celsius = "Celsius"
	case fahrenheit = "Fahrenheit"
}


// MARK: - Extension

extension TemperatureUnit {
	
	public static var defaultCase: TemperatureUnit {
		return .celsius
	}
}
