//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of user data object
@objcMembers class DBUserUnitPreferenceModel: Object {
	
	dynamic var clockHours: String = ""
	dynamic var consumptionCo: String = ""
	dynamic var consumptionEv: String = ""
	dynamic var consumptionGas: String = ""
	dynamic var speedDistance: String = ""
	dynamic var temperature: String = ""
	dynamic var tirePressure: String = ""

	let user = LinkingObjects(fromType: DBUserModel.self, property: "unitPreference")
}
