//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

protocol JwtTokenService {
	
	// MARK: Typealias
	typealias JwtServiceResult = ((Result<APIJwtTokenModel, LoginError>) -> Void)
	
	func getJwt(accessToken: String, completion: @escaping JwtServiceResult)
}


extension JwtTokenService {
	
	func getJwt(accessToken: String, completion: @escaping JwtServiceResult) {
		
		guard accessToken.isEmpty == false else {
			completion(.failure(LoginError.noValidJwtToken))
			return
		}
		
		let router = JwtEndpointRouter.jwt(accessToken: accessToken)
		NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APIJwtTokenModel>) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				completion(.failure(LoginError.noValidJwtToken))
				
			case .success(let value):
				completion(.success(value))
			}
		}
	}
}
