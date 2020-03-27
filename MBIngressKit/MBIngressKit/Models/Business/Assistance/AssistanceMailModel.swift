//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//


import Foundation

public struct AssistanceMailModel: Codable {
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
    
    public init (appName: String,
                 language: String,
                 firstName: String,
                 lastName: String,
                 streetName: String?,
                 streetNumber: String?,
                 zipCode: String,
                 city: String?,
                 country: String,
                 phone: String,
                 customerEmail: String,
                 device: String?,
                 os: String?,
                 appVersion: String,
                 messageText: String?) {
        
        self.appName = appName
        self.language = language
        self.firstName = firstName
        self.lastName = lastName
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.zipCode = zipCode
        self.city = city
        self.country = country
        self.phone = phone
        self.customerEmail = customerEmail
        self.device = device
        self.os = os
        self.appVersion = appVersion
        self.messageText = messageText
    }
}
