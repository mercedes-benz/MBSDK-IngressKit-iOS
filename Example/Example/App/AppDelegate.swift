//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBIngressKit
import MBCommonKit

let LOG = MBLogger.shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	// MARK: Properties
    var window: UIWindow?
	
	// setup service
	let stageEndpoint = StageEndpoint.ci
	let stageRegion = StageRegion.ece
	
	
	// MARK: - Methods
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// setup service
		let sdkVersion            = Bundle(for: IngressKit.self).shortVersion
		let bffProvider           = BffProvider(sdkVersion: sdkVersion)
		IngressKit.bffProvider       = bffProvider
		IngressKit.keycloackProvider = KeycloakProvider()
		
		// setup log
        LOG.register(logger: ConsoleLogger())
		
        return true
    }
}
