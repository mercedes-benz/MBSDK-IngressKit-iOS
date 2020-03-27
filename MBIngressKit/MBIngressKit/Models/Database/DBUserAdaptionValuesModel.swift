//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

/// Database class of user data object
@objcMembers class DBUserAdaptionValuesModel: Object {
    
    let bodyHeight = RealmOptional<Int>()
    let preAdjustment = RealmOptional<Bool>()

    let user = LinkingObjects(fromType: DBUserModel.self, property: "adaptionValues")
}
