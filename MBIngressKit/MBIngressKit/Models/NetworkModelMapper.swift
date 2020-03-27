//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

class NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiAgreementDocModels: [APIAgreementDocModel]) -> [AgreementDocModel] {
		return apiAgreementDocModels.map { self.map(apiAgreementDocModel: $0) }
	}
	
	static func map(apiAgreementDocModel: APIAgreementDocModel) -> AgreementDocModel {
		return AgreementDocModel(acceptedByUser: apiAgreementDocModel.acceptedByUser,
								 acceptedLocale: apiAgreementDocModel.acceptedLocale ?? "",
								 documentId: apiAgreementDocModel.documentId,
								 version: apiAgreementDocModel.version)
	}
    
    static func map(apiAgreementsModel: APIAgreementsModel) -> AgreementsModel {
		return AgreementsModel(ciam: apiAgreementsModel.ciam?.map { self.map(apiCiamAgreementModel: $0) } ?? [],
							   custom: apiAgreementsModel.custom?.map { self.map(apiCustomAgreementModel: $0) } ?? [],
							   natCon: apiAgreementsModel.natcon?.map { self.map(apiNatconAgreementModel: $0) } ?? [],
                               soe: apiAgreementsModel.soe?.map { self.map(apiSoeAgreementModel: $0) } ?? [],
                               ldsso: apiAgreementsModel.ldsso?.map { self.map(apiLdssoAgreementModel: $0) } ?? [])
    }
    
    static func map(apiSoeAgreementModel: APISoeAgreementModel) -> SoeAgreementModel {
        return SoeAgreementModel(href: apiSoeAgreementModel.href,
                                 documentID: apiSoeAgreementModel.documentID,
                                 version: apiSoeAgreementModel.version,
                                 position: apiSoeAgreementModel.position,
                                 displayName: apiSoeAgreementModel.displayName,
                                 acceptanceState: apiSoeAgreementModel.acceptanceState,
                                 checkBoxTextKey: apiSoeAgreementModel.checkBoxTextKey,
                                 isGeneralUserAgreement: apiSoeAgreementModel.isGeneralUserAgreement,
                                 checkBoxText: apiSoeAgreementModel.checkBoxText,
                                 titleText: apiSoeAgreementModel.titleText)
    }
    
    static func map(apiCiamAgreementModel: APICiamAgreementModel) -> CiamAgreementModel {
        return CiamAgreementModel(acceptanceState: apiCiamAgreementModel.acceptanceState,
                                  href: apiCiamAgreementModel.href,
                                  documentID: apiCiamAgreementModel.documentID,
                                  version: apiCiamAgreementModel.version)
    }
    
    static func map(apiLdssoAgreementModel: APILdssoAgreementModel) -> LdssoAgreementModel {
        return LdssoAgreementModel(documentID: apiLdssoAgreementModel.documentID,
                                   locale: apiLdssoAgreementModel.locale,
                                   version: apiLdssoAgreementModel.version,
                                   position: apiLdssoAgreementModel.position,
                                   displayName: apiLdssoAgreementModel.displayName,
                                   implicitConsent: apiLdssoAgreementModel.implicitConsent,
                                   href: apiLdssoAgreementModel.href,
                                   acceptanceState: apiLdssoAgreementModel.acceptanceState)
    }
    
    static func map(apiNatconAgreementModel: APINatconAgreementModel) -> NatConAgreementModel {
        return NatConAgreementModel(acceptanceState: apiNatconAgreementModel.acceptanceState ?? .unseen,
                                    termsId: apiNatconAgreementModel.termsId,
                                    description: apiNatconAgreementModel.description,
                                    isMandatory: apiNatconAgreementModel.isMandatory,
                                    position: apiNatconAgreementModel.position,
                                    text: apiNatconAgreementModel.text,
                                    title: apiNatconAgreementModel.title,
                                    href: apiNatconAgreementModel.href,
                                    version: apiNatconAgreementModel.version)
    }
    
    static func map(apiCustomAgreementModel: APICustomAgreementModel) -> CustomAgreementModel {
        return CustomAgreementModel(acceptanceState: apiCustomAgreementModel.acceptanceState,
                                    displayLocation: apiCustomAgreementModel.displayLocation,
                                    displayName: apiCustomAgreementModel.displayName,
                                    position: apiCustomAgreementModel.position,
                                    documentID: apiCustomAgreementModel.documentID,
                                    href: apiCustomAgreementModel.href,
                                    version: apiCustomAgreementModel.version)
    }
	
	static func map(apiAgreementConfirmModel: APIAgreementConfirmModel) -> AgreementConfirmModel {
		return AgreementConfirmModel(agreementConsents: apiAgreementConfirmModel.allUserAgreementConsentsSet ?? false,
									 unsuccessfulIds: apiAgreementConfirmModel.unsuccessfulSetDocIds)
	}
	
	static func map(apiAgreementModels: [APIAgreementModel]) -> [AgreementModel] {
		return apiAgreementModels.map { self.map(apiAgreementModel: $0) }
	}
	
	static func map(apiAgreementModel: APIAgreementModel) -> AgreementModel {
		
		let documentData = Data(base64Encoded: apiAgreementModel.documentData)
		return AgreementModel(documentData: documentData,
							  documents: self.map(apiAgreementDocModels: apiAgreementModel.documents))
	}
	
	static func map(apiCountries: [APICountryModel]) -> [CountryModel] {
		return apiCountries.map { self.map(apiCountry: $0) }
	}
	
	static func map(apiCountry: APICountryModel) -> CountryModel {
		return CountryModel(availability: apiCountry.availability,
                            countryCode: apiCountry.countryCode,
							countryName: apiCountry.countryName,
							instance: apiCountry.instance,
							legalRegion: apiCountry.legalRegion,
                            locales: self.map(apiCountryLocales: apiCountry.locales ?? [] ),
                            natconCountry: apiCountry.natconCountry)
	}
    
    static func map(apiCountryLocales: [APICountryLocaleModel]) -> [CountryLocaleModel] {
        return apiCountryLocales.map { self.map(apiCountryLocale: $0) }
    }
    
    static func map(apiCountryLocale: APICountryLocaleModel) -> CountryLocaleModel {
		return CountryLocaleModel(localeCode: apiCountryLocale.localeCode,
								  localeName: apiCountryLocale.localeName)
    }
	
	static func map(apiLogin: APILoginModel) -> Token {
		
		let tokenType = TokenType(rawValue: apiLogin.tokenType) ?? .native
		return Token(accessToken: apiLogin.accessToken,
					 expirationDate: Date().addingTimeInterval(TimeInterval(apiLogin.expiresIn)),
					 refreshToken: apiLogin.refreshToken,
					 sessionState: apiLogin.sessionState,
					 tokenType: tokenType)
	}
	
	static func map(apiLogin: APILoginModel, apiJwt: APIJwtTokenModel) -> Token {
		
		let tokenType = TokenType(rawValue: apiLogin.tokenType) ?? .native
		return Token(accessToken: apiLogin.accessToken,
					 expirationDate: Date().addingTimeInterval(TimeInterval(apiLogin.expiresIn)),
					 refreshToken: apiLogin.refreshToken,
					 sessionState: "",
					 tokenType: tokenType)
	}
	
	static func map(apiRegistrationUser: APIRegistrationUserModel) -> RegistrationUserModel {
		return RegistrationUserModel(countryCode: apiRegistrationUser.countryCode,
									 email: apiRegistrationUser.email,
									 firstName: apiRegistrationUser.firstName,
									 lastName: apiRegistrationUser.lastName,
									 mobileNumber: apiRegistrationUser.mobileNumber,
									 useEmailAsUsername: apiRegistrationUser.useEmailAsUsername,
									 userName: apiRegistrationUser.username)
	}
	
	static func map(apiUserExist: APIUserExistModel) -> UserExistModel {
		return UserExistModel(isEmail: apiUserExist.isEmail,
							  username: apiUserExist.username)
	}
	
	static func map(apiUser: APIUserModel) -> UserModel {
		return UserModel(address: self.map(apiUserAddress: apiUser.address),
						 birthday: DateFormattingHelper.date(apiUser.birthday, format: DateFormat.birthday),
						 ciamId: apiUser.ciamId,
						 createdAt: apiUser.createdAt,
						 email: apiUser.email,
						 firstName: apiUser.firstName,
						 lastName1: apiUser.lastName1,
                         lastName2: apiUser.lastName2 ?? "",
						 landlinePhone: apiUser.landlinePhone,
						 mobilePhoneNumber: apiUser.mobilePhoneNumber,
						 updatedAt: apiUser.updatedAt,
                         accountCountryCode: apiUser.accountCountryCode ?? "",
                         userPinStatus: UserPinStatus(rawValue: apiUser.userPinStatus ?? UserPinStatus.unknown.rawValue) ?? .unknown,
						 communicationPreference: self.map(preference: apiUser.communicationPreference),
						 profileImageData: nil,
                         unitPreferences: self.map(preference: apiUser.unitPreferences),
                         salutation: apiUser.salutationCode,
                         title: apiUser.title,
                         taxNumber: apiUser.taxNumber,
                         namePrefix: apiUser.namePrefix,
                         preferredLanguageCode: apiUser.preferredLanguageCode ?? "",
                         middleInitial: apiUser.middleInitial,
                         accountIdentifier: apiUser.accountIdentifier,
						 adaptionValues: self.map(apiAdaptionValues: apiUser.adaptionValues),
						 accountVerified: apiUser.accountVerified ?? false)
	}
	
	private static func map(apiUserAddress: APIUserAddressModel?) -> UserAddressModel {
		return UserAddressModel(city: apiUserAddress?.city,
								countryCode: apiUserAddress?.countryCode,
								houseNo: apiUserAddress?.houseNo,
								state: apiUserAddress?.state,
								street: apiUserAddress?.street,
								zipCode: apiUserAddress?.zipCode,
                                province: apiUserAddress?.province,
                                doorNo: apiUserAddress?.doorNo,
                                addressLine1: apiUserAddress?.addressLine1,
                                streetType: apiUserAddress?.streetType,
                                houseName: apiUserAddress?.houseName,
                                floorNo: apiUserAddress?.floorNo,
                                addressLine2: apiUserAddress?.addressLine2,
                                addressLine3: apiUserAddress?.addressLine3,
                                postOfficeBox: apiUserAddress?.postOfficeBox)
	}
	
	private static func map(preference: APIUserCommunicationPreferenceModel?) -> UserCommunicationPreferenceModel {
		return UserCommunicationPreferenceModel(phone: preference?.contactedByPhone,
											letter: preference?.contactedByLetter,
											email: preference?.contactedByEmail,
											sms: preference?.contactedBySms)
	}
	
	private static func map(preference: APIUserUnitPreferenceModel) -> UserUnitPreferenceModel {
		return UserUnitPreferenceModel(clockHours: preference.clockHours,
									   consumptionCo: preference.consumptionCo,
									   consumptionEv: preference.consumptionEv,
									   consumptionGas: preference.consumptionGas,
									   speedDistance: preference.speedDistance,
									   temperature: preference.temperature,
									   tirePressure: preference.tirePressure)
	}
    
    private static func map(apiAdaptionValues: APIUserAdaptionValuesModel?) -> UserAdaptionValuesModel? {
        
        guard let apiAdaptionValues = apiAdaptionValues else {
            return nil
        }
        
        return UserAdaptionValuesModel(bodyHeight: apiAdaptionValues.bodyHeight, preAdjustment: apiAdaptionValues.preAdjustment)
    }
	
	
	// MARK: - APIModel
	
	private static func map(userAddress: UserAddressModel) -> APIUserAddressModel {
		return APIUserAddressModel(countryCode: userAddress.countryCode,
								   state: userAddress.state,
								   province: userAddress.province,
								   street: userAddress.street,
								   houseNo: userAddress.houseNo,
								   zipCode: userAddress.zipCode,
								   city: userAddress.city,
								   streetType: userAddress.streetType,
								   houseName: userAddress.houseName,
                                   floorNo: userAddress.floorNo,
								   doorNo: userAddress.doorNo,
								   addressLine1: userAddress.addressLine1,
								   addressLine2: userAddress.addressLine2,
								   addressLine3: userAddress.addressLine3,
								   postOfficeBox: userAddress.postOfficeBox)
	}
	
	static func map(user: UserModel) -> APIUserModel {
        let communicationPreference = APIUserCommunicationPreferenceModel(contactedByPhone: user.communicationPreference.phone,
                                                                          contactedByLetter: user.communicationPreference.letter,
                                                                          contactedByEmail: user.communicationPreference.email,
                                                                          contactedBySms: user.communicationPreference.sms)
		return APIUserModel(ciamId: user.ciamId,
							firstName: user.firstName,
							lastName1: user.lastName1,
                            lastName2: user.lastName2,
							title: user.title,
							namePrefix: user.namePrefix,
							middleInitial: user.middleInitial,
							salutationCode: user.salutation,
							email: user.email,
							landlinePhone: user.landlinePhone,
							mobilePhoneNumber: user.mobilePhoneNumber,
							birthday: DateFormattingHelper.string(user.birthday, format: DateFormat.birthday),
							preferredLanguageCode: user.preferredLanguageCode,
							accountCountryCode: user.accountCountryCode,
							createdAt: user.createdAt,
							createdBy: nil,
							updatedAt: user.updatedAt,
							address: self.map(userAddress: user.address),
							communicationPreference: communicationPreference,
                            userPinStatus: user.userPinStatus.rawValue,
							unitPreferences: self.map(preference: user.unitPreferences),
                            taxNumber: user.taxNumber,
                            accountIdentifier: user.accountIdentifier,
                            useEmailAsUsername: user.accountIdentifier == "email",
                            adaptionValues: self.map(adaptionValues: user.adaptionValues),
							accountVerified: user.accountVerified)
	}
	
	static func map(preference: UserCommunicationPreferenceModel) -> APIUserCommunicationPreferenceModel {
		return APIUserCommunicationPreferenceModel(contactedByPhone: preference.phone,
												   contactedByLetter: preference.letter,
												   contactedByEmail: preference.email,
												   contactedBySms: preference.sms)
	}
	
	static func map(preference: UserUnitPreferenceModel) -> APIUserUnitPreferenceModel {
		return APIUserUnitPreferenceModel(clockHours: preference.clockHours,
										  consumptionCo: preference.consumptionCo,
										  consumptionEv: preference.consumptionEv,
										  consumptionGas: preference.consumptionGas,
										  speedDistance: preference.speedDistance,
										  temperature: preference.temperature,
										  tirePressure: preference.tirePressure)
	}
    
    static func map(assistanceMailModel: AssistanceMailModel) -> APIAssistanceMailModel {
        return APIAssistanceMailModel(appName: assistanceMailModel.appName,
                                      language: assistanceMailModel.language,
                                      firstName: assistanceMailModel.firstName,
                                      lastName: assistanceMailModel.lastName,
                                      streetName: assistanceMailModel.streetName,
                                      streetNumber: assistanceMailModel.streetName,
                                      zipCode: assistanceMailModel.zipCode,
                                      city: assistanceMailModel.city,
                                      country: assistanceMailModel.country,
                                      phone: assistanceMailModel.phone,
                                      customerEmail: assistanceMailModel.customerEmail,
                                      device: assistanceMailModel.device,
                                      os: assistanceMailModel.os,
                                      appVersion: assistanceMailModel.appVersion,
                                      messageText: assistanceMailModel.messageText)
    }
    
    static func map(adaptionValues: UserAdaptionValuesModel?) -> APIUserAdaptionValuesModel? {
        return APIUserAdaptionValuesModel(bodyHeight: adaptionValues?.bodyHeight,
                                     preAdjustment: adaptionValues?.preAdjustment)
    }
}
