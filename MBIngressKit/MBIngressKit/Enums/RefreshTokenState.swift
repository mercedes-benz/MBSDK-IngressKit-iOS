//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

enum RefreshTokenState {
	case error(error: MBError)
	case finished
	case new(token: Token)
	case started(retrierCount: Int)
}
