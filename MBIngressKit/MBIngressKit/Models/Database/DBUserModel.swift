//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

/// Database class of user data object
@objcMembers public class DBUserModel: Object {
	
	dynamic var userId: String = ""
	dynamic var ciamId: String = ""
	dynamic var firstName: String = ""
	dynamic var lastName1: String = ""
	dynamic var lastName2: String?
	dynamic var title: String?
	dynamic var namePrefix: String?
	dynamic var middleInitial: String?
	dynamic var salutationCode: String?
	dynamic var email: String?
	dynamic var landlinePhone: String?
	dynamic var mobilePhoneNumber: String?
	dynamic var birthday: String?
	dynamic var preferredLanguageCode: String?
	dynamic var accountCountryCode: String?
	dynamic var createdAt: String = ""
	dynamic var createdBy: String?
	dynamic var updatedAt: String = ""
	dynamic var address: DBUserAddressModel?
	dynamic var communicationPreference: DBUserCommunicationPreferenceModel?
	dynamic var userPinStatus: String?
	dynamic var profileImageData: Data?
	dynamic var unitPreference: DBUserUnitPreferenceModel?
    dynamic var taxNumber: String?
	dynamic var adaptionValues: DBUserAdaptionValuesModel?
	dynamic var accountVerified: Bool = false
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "ciamId"
	}
}
