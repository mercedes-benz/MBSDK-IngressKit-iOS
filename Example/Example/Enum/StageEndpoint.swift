//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Available backend stages
public enum StageEndpoint: String, CaseIterable {
    case ci
    case int
	case mock
    case prod
}
