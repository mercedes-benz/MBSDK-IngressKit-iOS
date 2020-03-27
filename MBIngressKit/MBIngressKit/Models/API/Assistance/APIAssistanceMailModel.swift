//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//


import Foundation

struct APIAssistanceMailModel: Codable {
    let appName: String
    let language: String
    let firstName: String
    let lastName: String
    var streetName: String?
    var streetNumber: String?
    let zipCode: String
    var city: String?
    let country: String
    let phone: String
    let customerEmail: String
    var device: String?
    var os: String?
    let appVersion: String
    var messageText: String?
    
    enum CodingKeys: String, CodingKey {
        case appName, language, firstName, lastName, streetName, streetNumber, zipCode, city, country, phone, customerEmail, device
        case os = "OS"
        case appVersion, messageText
    }
}
