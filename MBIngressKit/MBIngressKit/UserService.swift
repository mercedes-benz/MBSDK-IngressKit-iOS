//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBNetworkKit

// swiftlint:disable type_body_length
/// Service to call all user related requests
public class UserService {
	
	// MARK: Typealias
	
	/// Completion for agreement
	///
	/// Returns array of AgreementModel
	public typealias AgreementResult = (Result<[AgreementModel], MBError>) -> Void
    
    /// Completion for agreements
    ///
    /// Returns array of AgreementsModel
    public typealias AgreementsResult = (Result<AgreementsModel, MBError>) -> Void
    
    /// Completion for submit the user agreements
    ///
    /// Returns NonValueResult with error or success
    public typealias UserAgreementsSubmitResult = (EmptyResult) -> Void
	
	/// Completion for confirm the agreement
	///
	/// Returns AgreementConfirmModel
	public typealias AgreementConfirmResult = (Result<AgreementConfirmModel, MBError>) -> Void

    /// Completion for update unit preference-request
    ///
    /// Returns NonValueResult with error or success
    public typealias AnnounceBiometricAuthenticationResult = (EmptyResult) -> Void

    /// Completion for Send an email request
    ///
    /// Returns NonValueResult with error or success
    public typealias AssistancEmailResult = (EmptyResult) -> Void
    
	/// Completion for countries-request
	///
	/// returns array of CountryModel or error
	public typealias CountriesResult = (Result<[CountryModel], MBError>) -> Void
    
    /// Completion for image-download
    ///
    /// Returns UIImage (optional)
	public typealias ProfileImageResult = (UIImage?) -> Void
    
    /// Completion for image upload
	public typealias ProfileImageUploadResult = (ProgressResult) -> Void
    
    /// Completion for profile's fields-request
    ///
    /// Returns ProfileFieldModel (optional)
    public typealias ProfileFieldsResult = (Result<[ProfileFieldModel], MBError>) -> Void
	
	/// Completion for Pin requests
	public typealias PinResult = (EmptyResult) -> Void
	
    /// Error-completion for wrong Pin
    public typealias WrongPinError = () -> Void
    
	/// Completion for create user request
    ///
    /// returns RegistrationUserResult
	public typealias RegistrationUserResult = (Result<RegistrationUserModel, RegistrationError>) -> Void

	/// Error-completion for create-request in case conflict
    ///
    /// returns ConflictUserError
    public typealias ConflictUserError = () -> Void
	
	/// Completion for delete-request
	///
	/// Returns NonValueResult with error or success
	public typealias UserDeleteResult = (EmptyResult) -> Void
	
    /// Completion for userExist-request
    ///
    /// returns UserExitModel or error
	public typealias UserExistResult = (Result<UserExistModel, RegistrationError>) -> Void
    
    /// Completion for fetchUser-request
    ///
    /// returns UserModel or error
	public typealias UserServiceResult = (Result<UserModel, MBError>) -> Void
	
	/// Completion for fetchUser-request
    ///
    /// returns UserModel or error
	public typealias UpdateUserResult = (Result<UserModel, RegistrationError>) -> Void
	
	/// Completion for unit preference-request
	///
	/// returns UserUnitPreferenceModel or error
	public typealias UserUnitPreferenceResult = (UserUnitPreferenceModel) -> Void
	
	/// Completion for update unit preference-request
	///
	/// Returns NonValueResult with error or success
	public typealias UpdateUserUnitPreferenceResult = (EmptyResult) -> Void
    
    /// Completion for update adaption Values-request
    ///
    /// Returns NonValueResult with error or success
    public typealias UpdateAdaptionValuesResult = (EmptyResult) -> Void

    /// Completion for verification-request
    ///
    /// Returns NonValueResult with error or success
    public typealias UserVerificationResult = (EmptyResult) -> Void

	
    /// Session error result. Called when refreshTokenIfNeeded failed
    ///
    /// returns a ResponseError with a localized description
    public typealias SessionErrorResult = (_ error: MBError) -> Void
	
	
	// MARK: - Public
	
    /// Get user if user has valid token
	public var validUser: UserModel? {
		return DatabaseUserService.cachedUser()
	}
    
	/// Fetch the agreements for an user
	///
	/// - Parameters:
	///   - completion: Success closure with ValueResult including an array of AgreementModels
	///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
	public func agreement(completion: @escaping AgreementResult, onSessionError: @escaping SessionErrorResult) {
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffAgreementRouter.get(accessToken: token.accessToken,
												countryCode: IngressKit.countryCode,
												locale: IngressKit.localeIdentifier)
			
			NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<[APIAgreementModel]>) in
				
				switch result {
				case .failure(let error):
					completion(.failure(ErrorHandler.handle(error: error)))
					
				case .success(let apiAgreements):
					let agreements = NetworkModelMapper.map(apiAgreementModels: apiAgreements)
					completion(.success(agreements))
				}
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
    
    /// Fetch the agreements
    ///
    /// - Parameters:
    ///   - completion: Success closure with ValueResult including an array of AgreementModels
    ///   - countryCode: The address country. Format: [ISO 3166 ALPHA2]. Valid examples: DE, GB, AE-AZ.
    ///   - locale: Format [ISO 639-1]-[ISO 3166 ALPHA2]. Valid examples: de-DE, zh-CN.
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func agreements(countryCode: String, locale: String, completion: @escaping AgreementsResult) {
        
		let router = BffAgreementRouter.get(accessToken: nil,
											countryCode: countryCode,
											locale: locale)
		
		NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APIAgreementsModel>) in
			
			switch result {
			case .failure(let error):
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success(let agreements):
				let agreements = NetworkModelMapper.map(apiAgreementsModel: agreements)
				completion(.success(agreements))
			}
		}
    }
    
    /// Fetch the agreements for an user
    ///
    /// - Parameters:
    ///   - completion: Success closure with ValueResult including an array of AgreementModels
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func userAgreements(countryCode: String, locale: String, completion: @escaping AgreementsResult, onSessionError: @escaping SessionErrorResult) {
        
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            
			let router = BffAgreementRouter.get(accessToken: token.accessToken,
												countryCode: countryCode,
												locale: locale)
            
            NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APIAgreementsModel>) in
                
                switch result {
                case .failure(let error):
					completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiUserAgreements):
                    let agreements = NetworkModelMapper.map(apiAgreementsModel: apiUserAgreements)
                    completion(.success(agreements))
                }
            }
        }, onError: { (error) in
            onSessionError(error)
        })
    }
    
    /// Submit the user agreements
    ///
    /// - Parameters:
    ///   - agreements: The model with the submitting  agreements
    ///   - completion: Success closure with UserAgreementsSubmitResult
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func userAgreementsSubmit(agreements: AgreementsSubmitModel, completion: @escaping UserAgreementsSubmitResult, onSessionError: @escaping SessionErrorResult) {
        
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            let json = try? agreements.toJson()
            let requestDict = json as? [String: Any]
            
            let router = BffAgreementRouter.update(accessToken: token.accessToken,
												   locale: IngressKit.localeIdentifier,
												   requestModel: requestDict)
            
            NetworkLayer.requestData(router: router) { (response) in
                
                switch response {
                case .failure(let error):
					completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success:
                    completion(.success)
                }
            }
        }, onError: { (error) in
            onSessionError(error)
        })
    }
    
    /// Announce that the biometric authentication will be used
    ///
    /// - Parameters:
    ///   - pinModel: PinValidationModel if biometric authentication should be en-/disabled
    ///   - completion: AnnounceBiometricAuthenticationResult closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func announceBiometricAuthentication(pinModel: PinValidationModel, completion: @escaping AnnounceBiometricAuthenticationResult, onSessionError: @escaping SessionErrorResult) {

        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffUserRouter.biometric(accessToken: token.accessToken,
												 dict: pinModel.parameters)
			
			self.requestPin(router: router,
							completion: completion,
							onWrongPinError: nil)
        }, onError: { (error) in
            onSessionError(error)
        })
    }
		
    /// Sends an email with the relevant information about the driver.
    ///
    /// - Parameters:
    ///   - assistanceMailModel:  model with all driver related information and message
    ///   - completion: AssistancEmailResult closure
    public func assistancemail(assistanceMailModel: AssistanceMailModel, completion: @escaping AssistancEmailResult) {
        
        let apiAssistanceMailModel = NetworkModelMapper.map(assistanceMailModel: assistanceMailModel)
        
        guard let json = try? apiAssistanceMailModel.toJson() as? [String: Any] else {
            return
        }
        
        let router = BffEndpointRouter.assistancemail(dict: json)
        NetworkLayer.requestData(router: router) { (response) in
            
            switch response {
            case .failure(let error):
				completion(.failure(ErrorHandler.handle(error: error)))
                
            case .success:
                completion(.success)
            }
        }
    }
    
	/// Fetch a list of countries, including localized names, countryCode and regions
	///
	/// - Parameter completion: CountriesResult-closure
	public func countries(completion: @escaping CountriesResult) {
		
		let router = BffEndpointRouter.countries
		
		NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<[APICountryModel]>) in
			
			switch result {
			case .failure(let error):
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success(let apiCountries):
				let countries = NetworkModelMapper.map(apiCountries: apiCountries)
				completion(.success(countries))
			}
		}
	}
	
    /// Register/create a new user
    ///
    /// - Parameters:
    ///   - user: user model with all registartion related information
    ///   - completion: RegistrationUserResult closure
    ///   - onConflict: ConflictUserError closure if there exists a user with the same credentials
	public func create(user: UserModel, completion: @escaping RegistrationUserResult, onConflict: @escaping ConflictUserError) {

		let apiUser = NetworkModelMapper.map(user: user)
		guard let json = try? apiUser.toJson() as? [String: Any] else {
			return
		}
		
        let router = BffUserRouter.create(countryCode: user.accountCountryCode, locale: user.preferredLanguageCode, dict: json)
		NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APIRegistrationUserModel>) in

			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				let mbError = ErrorHandler.handle(error: error)
				switch mbError.type {
				case .http(let httpError):

					if httpError == .conflict(data: nil) {
						onConflict()
					} else {
						
						let apiError: APIError? = NetworkLayer.parse(httpError: httpError)
						if let apiError = apiError {
							
							let registrationError = NetworkModelMapper.map(apiError: apiError)
							completion(.failure(registrationError))
						}
					}
					
				case .network,
					 .unknown:
					let registrationError = NetworkModelMapper.map(apiError: mbError)
					completion(.failure(registrationError))
				}
				
			case .success(let apiRegistrationUser):
				LOG.D(apiRegistrationUser)
				
				let registerUserModel = NetworkModelMapper.map(apiRegistrationUser: apiRegistrationUser)
				completion(.success(registerUserModel))
			}
		}
	}
    
    /// Delete user account
    ///
    /// on success the user and the token will be deleted
    ///
    /// - Parameters:
    ///   - completion: UserDeleteResult-closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func deleteUser(completion: @escaping UserDeleteResult, onSessionError: @escaping SessionErrorResult) {
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffUserRouter.delete(accessToken: token.accessToken)
			
			NetworkLayer.requestData(router: router) { (response) in
				
				switch response {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
					completion(.failure(ErrorHandler.handle(error: error)))
					
				case .success:
					DatabaseUserService.delete(method: .async)
					KeychainHelper.token = nil
					completion(.success)
				}
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
	
    /// Request a login-pin via mail or sms
    ///
    /// If the username in the response == "" --> the user is not registered
    ///
    /// - Parameters:
    ///   - username: email or phone-number
    ///   - completion: UserExistResult-closure
	public func existUser(username: String, completion: @escaping UserExistResult) {
		
		let loginUser = LoginUserModel(countryCode: IngressKit.countryCode,
									   emailOrPhoneNumber: username,
									   locale: IngressKit.localeIdentifier)
		guard let json = try? loginUser.toJson() as? [String: Any] else {
			return
		}
		
		let router = BffUserRouter.exist(dict: json)
		
		NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APIUserExistModel>) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				guard let error = self.handle(error: error) else {
					return
				}
				completion(.failure(error))
				
			case .success(let apiUserExist):
				LOG.D(apiUserExist)
				
				let userExistModel = NetworkModelMapper.map(apiUserExist: apiUserExist)
				completion(.success(userExistModel))
			}
		}
	}
	
	/// Fetch the unit preferences for a user
	///
	/// - Parameters:
	///   - completion: UserUnitPreferenceResult closure
	///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
	public func fetchUnitPreferences(completion: @escaping UserUnitPreferenceResult, onSessionError: @escaping SessionErrorResult) {
		
		if let userModel = DatabaseUserService.cachedUser() {
			completion(userModel.unitPreferences)
		}
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffUserRouter.get(accessToken: token.accessToken)
			NetworkLayer.requestDecodable(router: router) { [weak self] (result: NetworkResult<APIUserModel>) in
				
				self?.handle(result: result, updateCache: true, completion: { (result) in
					
					switch result {
					case .failure(let error):		LOG.E(error)
					case .success(let userModel):	completion(userModel.unitPreferences)
					}
				})
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
	
    /// Fetch the user data
    ///
    /// - Parameters:
    ///   - completion: UserServiceResult-closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func fetchUser(completion: @escaping UserServiceResult, onSessionError: @escaping SessionErrorResult) {
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
		
			let router = BffUserRouter.get(accessToken: token.accessToken)
			NetworkLayer.requestDecodable(router: router) { [weak self] (result: NetworkResult<APIUserModel>) in
				self?.handle(result: result, updateCache: true, completion: completion)
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
    
    /// Load the user's profile image
    ///
    /// - Parameters:
    ///   - completion: ProfileImageResult-closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func fetchUserImage(completion: ProfileImageResult?, onSessionError: @escaping SessionErrorResult) {
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
		
			let router = BffImageRouter.get(accessToken: token.accessToken)
			
			LOG.D("\(String(describing: router.urlRequest?.url?.absoluteString)) with \(String(describing: router.httpHeaders))")
			
			NetworkLayer.requestImage(router: router) { (result) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					completion?(nil)
					
				case .success(let image):
					if let jpegData = image.jpegData(compressionQuality: 1.0) {
						DatabaseUserService.update(imageData: jpegData, for: token.ciamId)
					} else if let pngData = image.pngData() {
						DatabaseUserService.update(imageData: pngData, for: token.ciamId)
					}
					completion?(image)
				}
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
    
    /// Register a scanReference (uuid) for the current user
    ///
    /// - Parameters:
    ///   - scanReference: a uuid associated to the jumio scan.
    ///   - completion: UserVerificationResult-closure
    public func userVerification(scanReference: String, completion: @escaping UserVerificationResult, onSessionError: @escaping SessionErrorResult) {
        
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            
			let router = BffUserRouter.verification(accessToken: token.accessToken, scanReference: scanReference)
            
            NetworkLayer.requestData(router: router) { (response) in
                
                switch response {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success:
                    completion(.success)
                }
            }
        }, onError: { (error) in
            onSessionError(error)
        })
    }
    
    /// Fetch a list of mandatory and optional Profile/Account fields by given Country (localized by given Locale)
    ///
    /// - Parameter completion: ProfileFieldsResult-closure
    public func fetchProfileFields(countryCode: String, locale: String, completion: @escaping ProfileFieldsResult) {
        
        let router = BffEndpointRouter.profileFields(countryCode: countryCode, locale: locale)
        
        NetworkLayer.requestDecodable(router: router, keyPath: "customerDataFields") { (result: NetworkResult<[ProfileFieldModel]>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(ErrorHandler.handle(error: error)))
                
            case .success(let profileFields):
                completion(.success(profileFields))
            }
        }
    }
    
    /// Logout sets the current user to nil
	public func logout() {
		DatabaseUserService.delete(method: .async)
	}
	
	/// Change the pin for a given user
	///
	/// - Parameters:
	///   - pin: current pin of a given user
	///   - newPin: the new pin of a given user
	///   - completion: PinResult closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    ///   - onWrongPinError: WrongPinError. Called if the current pin is wrong
    public func change(pin: String, newPin: String, completion: @escaping PinResult, onSessionError: @escaping SessionErrorResult, onWrongPinError: @escaping WrongPinError) {
		
		let pinModel = PinModel(currentPin: pin,
								newPin: newPin)
		guard let json = try? pinModel.toJson() as? [String: Any] else {
			return
		}
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffPinRouter.change(accessToken: token.accessToken, dict: json)
            self.requestPin(router: router, completion: completion, onWrongPinError: onWrongPinError)
			
		}, onError: { (error) in
			onSessionError(error)
		})
	}
	
	/// Delete the pin for a given user
	///
	/// - Parameters:
	///   - pin: current pin of a given user
	///   - completion: PinResult closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    ///   - onWrongPinError: WrongPinError. Called if the current pin is wrong
    public func delete(pin: String, completion: @escaping PinResult, onSessionError: @escaping SessionErrorResult, onWrongPinError: @escaping WrongPinError) {
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffPinRouter.delete(accessToken: token.accessToken, pin: pin)
            self.requestPin(router: router, completion: completion, onWrongPinError: onWrongPinError)
		}, onError: { (error) in
			onSessionError(error)
		})
	}
    
    /// Resets a pin for a given user
    ///
    /// - Parameters:
    ///   - completion: PinResult closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func resetPin(completion: @escaping PinResult, onSessionError: @escaping SessionErrorResult) {
        
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            
            let router = BffPinRouter.reset(accessToken: token.accessToken)
            
            NetworkLayer.requestData(router: router) { (response) in
                
                switch response {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success:
                    completion(.success)
                }
            }
        }, onError: { (error) in
            onSessionError(error)
        })
    }
	
	/// Set a pin for a given user
	///
	/// - Parameters:
	///   - newPin: the pin of a given user
	///   - completion: PinResult closure
	///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
	public func set(pin: String, completion: @escaping PinResult, onSessionError: @escaping SessionErrorResult) {
		
		let pinModel = PinModel(currentPin: nil,
								newPin: pin)
		guard let json = try? pinModel.toJson() as? [String: Any] else {
			return
		}
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router = BffPinRouter.set(accessToken: token.accessToken, dict: json)
            self.requestPin(router: router, completion: completion, onWrongPinError: nil)
		}, onError: { (error) in
			onSessionError(error)
		})
	}
	
    /// Update the user data
    ///
    /// - Parameters:
    ///   - user: UserModel with changed information set
    ///   - completion: UpdateUserResult-closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func update(user: UserModel, completion: @escaping UpdateUserResult, onSessionError: @escaping SessionErrorResult) {
		
		let apiUser = NetworkModelMapper.map(user: user)
		guard let json = try? apiUser.toJson() as? [String: Any] else {
			return
		}
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router  = BffUserRouter.update(accessToken: token.accessToken, dict: json)
			
			NetworkLayer.requestData(router: router) { (result) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
					guard let error = self.handle(error: error) else {
						return
					}
					completion(.failure(error))
					
				case .success:
					LOG.D("update succeeded")
					
					DatabaseUserService.update(userModel: user) {
						completion(.success(user))
					}
				}
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
	
	/// Update the unit preferences
	///
	/// - Parameters:
	///   - unitPreference: UserUnitPreferenceModel with changed information set
	///   - completion: UserUnitPreferenceResult-closure
	///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
	public func update(unitPreference: UserUnitPreferenceModel, completion: @escaping UpdateUserUnitPreferenceResult, onSessionError: @escaping SessionErrorResult) {
		
		let apiUserUnitPreference = NetworkModelMapper.map(preference: unitPreference)
		guard let json = try? apiUserUnitPreference.toJson() as? [String: Any] else {
			return
		}
		
		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router  = BffUserRouter.updateUnitPreferences(accessToken: token.accessToken, dict: json)
			
			NetworkLayer.requestData(router: router) { (response) in
				
				switch response {
				case .failure(let error):
					completion(.failure(ErrorHandler.handle(error: error)))
					
				case .success:
					DatabaseUserService.update(unitPreference: unitPreference)
					completion(.success)
				}
			}
		}, onError: { (error) in
			onSessionError(error)
		})
	}
    
    /// Update the adaption values
    ///
    /// - Parameters:
    ///   - adaptionValues: UserAdaptionValuesModel with changed information set
    ///   - completion: UpdateAdaptionValuesResult-closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func update(adaptionValues: UserAdaptionValuesModel, completion: @escaping UpdateAdaptionValuesResult, onSessionError: @escaping SessionErrorResult) {
        
        let apiAdaptionValues = NetworkModelMapper.map(adaptionValues: adaptionValues)
        guard let json = try? apiAdaptionValues.toJson() as? [String: Any] else {
            return
        }
        
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            
			let router  = BffUserRouter.adaptionValues(accessToken: token.accessToken,
													   dict: json)
            
            NetworkLayer.requestData(router: router) { (response) in
                
                switch response {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success:
                    DatabaseUserService.update(adaptionValues: adaptionValues)
                    completion(.success)
                }
            }
        }, onError: { (error) in
            onSessionError(error)
        })
    }
	
    /// Upload user's profile image and update user cache
    ///
    /// - Parameters:
    ///   - data: image information converted to Data
    ///   - completion: ProfileUploadResult-closure
    ///   - onSessionError: SessionErrorResult. Called if refreshIfNeeded failed
    public func upload(data: Data, completion: @escaping ProfileImageUploadResult, onSessionError: @escaping SessionErrorResult) {

		IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
			
			let router  = BffImageRouter.upload(accessToken: token.accessToken)
			
			guard var urlRequest = router.urlRequest else {
				return
			}
			
			urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
			
			NetworkLayer.uploadImage(urlRequest: urlRequest, data: data) { (result: ProgressResult) in

				if result.isSuccess {
					DatabaseUserService.update(imageData: data, for: token.ciamId)
				}

                completion(result)
            }
		}, onError: { (error) in
			onSessionError(error)
		})
	}
	
	
	// MARK: - Helper
    
	private func handle(error: Error) -> RegistrationError? {
		
		let mbError = ErrorHandler.handle(error: error)
		switch mbError.type {
		case .http(let httpError):
			let apiError: APIError? = NetworkLayer.parse(httpError: httpError)
			if let apiError = apiError {
				return NetworkModelMapper.map(apiError: apiError)
			}

		case .network,
			 .unknown:
			return NetworkModelMapper.map(apiError: mbError)
		}
		
		return nil
	}
	
	private func handle(result: NetworkResult<APIUserModel>, updateCache: Bool, completion: @escaping UserServiceResult) {
		
		switch result {
		case .failure(let error):
			completion(.failure(ErrorHandler.handle(error: error)))
			
		case .success(let apiUser):
			LOG.D(apiUser)
			
			let userModel = NetworkModelMapper.map(apiUser: apiUser)
			
			guard updateCache == true else {
				completion(.success(userModel))
				return
			}
			
			DatabaseUserService.update(userModel: userModel) {
				completion(.success(userModel))
			}
		}
	}
	
	private func requestPin(router: EndpointRouter, completion: @escaping (EmptyResult) -> Void, onWrongPinError: WrongPinError?) {
		
		NetworkLayer.requestData(router: router) { (response) in
			
			switch response {
			case .failure(let error):
				let error = ErrorHandler.handle(error: error)
				switch error.type {
				case .http(let httpError):
					if httpError == .forbidden(data: nil) {
						if let onWrongPinError = onWrongPinError {
							onWrongPinError()
						} else {
							completion(.failure(error))
						}
					} else {
						completion(.failure(error))
					}
					
				case .network,
					 .unknown:
					completion(.failure(error))
				}
				
			case .success:
				completion(.success)
			}
		}
	}
}
