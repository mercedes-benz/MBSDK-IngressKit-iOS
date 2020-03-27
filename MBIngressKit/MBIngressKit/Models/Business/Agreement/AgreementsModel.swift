//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public class AgreementsModel: Codable {
    public var soe = [SoeAgreementModel]()
    public var ciam = [CiamAgreementModel]()
    public var natCon = [NatConAgreementModel]()
    public var custom = [CustomAgreementModel]()
    public var ldsso = [LdssoAgreementModel]()
    
    enum CodingKeys: String, CodingKey {
        case soe = "SOE"
        case ciam = "CIAM"
        case natCon = "NATCON"
        case custom = "CUSTOM"
        case ldsso = "LDSSO"
    }
	
	
	// MARK: - Init
	
	public init(ciam: [CiamAgreementModel], custom: [CustomAgreementModel], natCon: [NatConAgreementModel], soe: [SoeAgreementModel], ldsso: [LdssoAgreementModel]) {
		
		self.ciam = ciam
		self.custom = custom
		self.natCon = natCon
		self.soe = soe
        self.ldsso = ldsso
	}
}
