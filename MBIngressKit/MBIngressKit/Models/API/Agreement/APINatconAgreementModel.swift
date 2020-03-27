//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APINatconAgreementModel: Codable {
    
    let acceptanceState: APIAgreementAcceptanceState?
    let description: String
    let isMandatory: Bool
    let position: Int
    let text: String
    let title: String
    let href: String
    let termsId: String
    let version: String?
    
    enum CodingKeys: String, CodingKey {
        case acceptanceState
        case description
        case isMandatory
        case position
        case text
        case title
        case href
        case termsId
        case version
    }
}
