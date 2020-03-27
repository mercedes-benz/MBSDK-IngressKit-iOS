//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public extension Notification.Name {
	
	/// Will be sent when the user data was changed in cache
	///
	/// Returns the user as object of the notification
	/// - Returns:
	///   - object: the user as object of the notification
	///   - userInfo: A dictionary consists of the keys \"isNewUser\"
	static let didUpdateUser = Notification.Name("IngressKit.DidUpdateUser")
}
