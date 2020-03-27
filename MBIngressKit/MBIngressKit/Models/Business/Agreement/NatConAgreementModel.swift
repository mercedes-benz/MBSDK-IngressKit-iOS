//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of agreements document
public class NatConAgreementModel: Codable {
    
    public var acceptanceState: APIAgreementAcceptanceState
    public let termsId: String
    public let description: String
    public let isMandatory: Bool
    public let position: Int
    public let text: String
    public let title: String
    public let href: String
    public let version: String?
    public var isSelected: Bool = false
    public var accepted: Bool {
        get {
            return acceptanceState == .accepted
        }
        set {
            if newValue {
                self.acceptanceState = .accepted
            } else {
                self.acceptanceState = .rejected
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case acceptanceState
        case description
        case isMandatory
        case position
        case text
        case title
        case href
        case version
        case isSelected
        case termsId
    }
    
    public init(acceptanceState: APIAgreementAcceptanceState,
                termsId: String,
                description: String,
                isMandatory: Bool,
                position: Int,
                text: String,
                title: String,
                href: String,
                version: String?) {
        
        self.acceptanceState = acceptanceState
        self.termsId = termsId
        self.description = description
        self.isMandatory = isMandatory
        self.position = position
        self.text = text
        self.title = title
        self.href = href
        self.version = version
    }
}
