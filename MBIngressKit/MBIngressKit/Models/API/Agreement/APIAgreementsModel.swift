//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIAgreementsModel: Codable {
    let soe: [APISoeAgreementModel]?
    let ciam: [APICiamAgreementModel]?
    let natcon: [APINatconAgreementModel]?
    let custom: [APICustomAgreementModel]?
    let ldsso: [APILdssoAgreementModel]?
    
    enum CodingKeys: String, CodingKey {
        case soe = "SOE"
        case ciam = "CIAM"
        case natcon = "NATCON"
        case custom = "CUSTOM"
        case ldsso = "LDSSO"
    }
}
