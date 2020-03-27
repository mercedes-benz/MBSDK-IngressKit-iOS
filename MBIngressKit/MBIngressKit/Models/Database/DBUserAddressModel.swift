//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of user address object
@objcMembers class DBUserAddressModel: Object {
	
	dynamic var countryCode: String?
	dynamic var state: String?
	dynamic var province: String?
	dynamic var street: String?
	dynamic var houseNo: String?
	dynamic var zipCode: String?
	dynamic var city: String?
	dynamic var streetType: String?
	dynamic var houseName: String?
	dynamic var floorNo: String?
	dynamic var doorNo: String?
	dynamic var addressLine1: String?
	dynamic var addressLine2: String?
	dynamic var addressLine3: String?
	dynamic var postOfficeBox: String?
	
	let user = LinkingObjects(fromType: DBUserModel.self, property: "address")
}
