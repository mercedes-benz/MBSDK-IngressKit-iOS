//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

protocol LoginServiceProtocol {
	
	// MARK: Typealias
	typealias TokenResult = (Result<Token, MBError>) -> Void
	
	// MARK: Functions
	func login(completion: @escaping LoginService.LoginServiceResult)
	func logout(completion: @escaping LoginService.LoginServiceResult)
	func refreshTokenIfNeeded(retrierCount: Int, completion: @escaping TokenResult)
}
