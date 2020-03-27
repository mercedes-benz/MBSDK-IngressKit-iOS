//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
@testable import MBIngressKit

class EndpointTest: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	
	// MARK: - Tests
	
	func testJwtEndpoint() {

		IngressKit.bffProvider = BffProviderMock(sdkVersion: "v1_mock")
		let jwtEndpoint = JwtEndpointRouter.jwt(accessToken: "token")
		
		XCTAssertTrue(jwtEndpoint.baseURL.isEmpty)
		XCTAssertTrue(jwtEndpoint.httpHeaders != nil)
		XCTAssertTrue(jwtEndpoint.method == .get)
		XCTAssertTrue(jwtEndpoint.path.contains("getToken"))
		XCTAssertTrue(jwtEndpoint.parameters == nil)
		XCTAssertTrue(jwtEndpoint.parameterEncoding == .url(type: .standard))
		XCTAssertTrue(jwtEndpoint.cachePolicy == nil)
	}
	
	func testKeycloakEndpoint() {

		IngressKit.bffProvider = BffProviderMock(sdkVersion: "v1_mock")
		IngressKit.keycloackProvider = KeycloakProviderMock()
		let loginEndpoint = KeycloakEndpointRouter.login(username: "test", pin: "password")
		let logoutEndpoint = KeycloakEndpointRouter.logout(token: "token")
		let refreshEndpoint = KeycloakEndpointRouter.refresh(token: "token")
		
		XCTAssertTrue(loginEndpoint.baseURL.isEmpty == false)
		XCTAssertTrue(logoutEndpoint.baseURL.isEmpty == false)
		XCTAssertTrue(refreshEndpoint.baseURL.isEmpty == false)
		
		XCTAssertTrue(loginEndpoint.bodyEncoding == loginEndpoint.parameterEncoding)
		XCTAssertTrue(logoutEndpoint.bodyEncoding == logoutEndpoint.parameterEncoding)
		XCTAssertTrue(refreshEndpoint.bodyEncoding == refreshEndpoint.parameterEncoding)
		
		XCTAssertTrue(loginEndpoint.bodyParameters == nil)
		XCTAssertTrue(logoutEndpoint.bodyParameters == nil)
		XCTAssertTrue(refreshEndpoint.bodyParameters == nil)
		
		XCTAssertTrue(loginEndpoint.httpHeaders != nil)
		XCTAssertTrue(logoutEndpoint.httpHeaders != nil)
		XCTAssertTrue(refreshEndpoint.httpHeaders != nil)

		XCTAssertTrue(loginEndpoint.method == .post)
		XCTAssertTrue(logoutEndpoint.method == .get)
		XCTAssertTrue(refreshEndpoint.method == .post)
		
		XCTAssertTrue(loginEndpoint.path.contains("token"))
		XCTAssertTrue(logoutEndpoint.path.contains("logout"))
		XCTAssertTrue(refreshEndpoint.path.contains("token"))
		
		XCTAssertTrue(loginEndpoint.parameters != nil)
		XCTAssertTrue(logoutEndpoint.parameters != nil)
		XCTAssertTrue(refreshEndpoint.parameters != nil)
		
		XCTAssertTrue(loginEndpoint.parameterEncoding == .url(type: .standard))
		XCTAssertTrue(logoutEndpoint.parameterEncoding == .url(type: .standard))
		XCTAssertTrue(refreshEndpoint.parameterEncoding == .url(type: .standard))
		
		XCTAssertTrue(loginEndpoint.cachePolicy == nil)
		XCTAssertTrue(logoutEndpoint.cachePolicy == nil)
		XCTAssertTrue(refreshEndpoint.cachePolicy == nil)
		
		XCTAssertTrue(loginEndpoint.timeout == IngressKit.defaultRequestTimeout)
		XCTAssertTrue(logoutEndpoint.timeout == IngressKit.defaultRequestTimeout)
		XCTAssertTrue(refreshEndpoint.timeout == IngressKit.defaultRequestTimeout)
	}
	
	
	func testUserEndpoint() {
		
//		let createEnndpoint = BffEndpointRouter.userCreate(countryCode: "de", locale: "DE", dict: nil)
//		let deleteEndpoint  = BffEndpointRouter.userDelete(accessToken: "token")
//		let getEndpoint     = BffEndpointRouter.userGet(accessToken: "token")
//		let updateEndpoint  = BffEndpointRouter.userUpdate(accessToken: "token", dict: nil)
//		
//		XCTAssertTrue(createEnndpoint.baseURL.isEmpty == false)
//		XCTAssertTrue(deleteEndpoint.baseURL.isEmpty == false)
//		XCTAssertTrue(getEndpoint.baseURL.isEmpty == false)
//		XCTAssertTrue(updateEndpoint.baseURL.isEmpty == false)
//		
//		XCTAssertTrue(createEnndpoint.httpHeaders != nil)
//		XCTAssertTrue(deleteEndpoint.httpHeaders != nil)
//		XCTAssertTrue(getEndpoint.httpHeaders != nil)
//		XCTAssertTrue(updateEndpoint.httpHeaders != nil)
//		
//		XCTAssertTrue(createEnndpoint.method == .post)
//		XCTAssertTrue(deleteEndpoint.method == .delete)
//		XCTAssertTrue(getEndpoint.method == .get)
//		XCTAssertTrue(updateEndpoint.method == .put)
//		
//		XCTAssertTrue(createEnndpoint.path.contains("user"))
//		
//		XCTAssertTrue(createEnndpoint.parameters == nil)
//		XCTAssertTrue(deleteEndpoint.parameters == nil)
//		XCTAssertTrue(getEndpoint.parameters == nil)
//		XCTAssertTrue(updateEndpoint.parameters == nil)
//		
//		XCTAssertTrue(createEnndpoint.parameterEncoding == .json)
//		XCTAssertTrue(deleteEndpoint.parameterEncoding == .json)
//		XCTAssertTrue(getEndpoint.parameterEncoding == .json)
//		XCTAssertTrue(updateEndpoint.parameterEncoding == .json)
//		
//		XCTAssertTrue(createEnndpoint.cachePolicy == nil)
//		XCTAssertTrue(deleteEndpoint.cachePolicy == nil)
//		XCTAssertTrue(getEndpoint.cachePolicy == nil)
//		XCTAssertTrue(updateEndpoint.cachePolicy == nil)
	}
	
	func testRouter() {
		
		let loginEndpoint1 = KeycloakEndpointRouter.login(username: "test", pin: "password")
		
		XCTAssertTrue(loginEndpoint1.urlRequest != nil)
	}
}
