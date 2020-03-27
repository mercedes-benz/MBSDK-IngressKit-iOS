//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of user preferred units
public struct UserAdaptionValuesModel: Equatable {
    
    public let bodyHeight: Int?
    public let preAdjustment: Bool?

    // MARK: - Init
    
    public init(bodyHeight: Int?, preAdjustment: Bool?) {
        self.bodyHeight     = bodyHeight
        self.preAdjustment  = preAdjustment
    }
}
