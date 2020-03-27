//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBIngressKit

class ViewController: UIViewController {
	
    private struct User {
        
		static let elonMusk = "elon@r1s.xyz"
		static let johnNeuman = "john@r1s.xyz"
        static let nonRegisteredUser = "steve@jobs.xyz"
    }
    
    enum Const {
        static let invalidSessionMessage = "Your session is invalid"
    }
    
    
    // MARK: - Properties
    
	@IBOutlet weak var imageView: UIImageView!
	
	
	// MARK: - View life cycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
	}
	
	
	// MARK: - Button Actions
	
    @IBAction func sendPinButtonTapped(_ sender: Any) {
        self.userExist()
    }
    
	@IBAction func loginUserButtonTapped(_ sender: UIButton) {
		self.login()
	}
    
    @IBAction func createUserButtonTapped(_ sender: Any) {
        self.register()
    }
    
    @IBAction func refreshTokenButtonTapped(_ sender: Any) {
        self.refreshToken()
    }
    
    @IBAction func fetchUserButtonTapped(_ sender: Any) {
        self.fetchUser()
    }
    
    @IBAction func updateUserButtonTapped(_ sender: Any) {
        self.updateUser()
    }
    
	@IBAction func setPin(_ sender: Any) {
		
		let newPin = "1234"
        IngressKit.userService.set(pin: newPin, completion: { (result) in
            
            switch result {
            case .failure(let error):    print(error.localizedDescription ?? "error")
            case .success:               print("success")
            }
            
        }, onSessionError: { error in
            LOG.E(Const.invalidSessionMessage + "\(error)")
        })
	}
	
	@IBAction func changePin(_ sender: Any) {
		
		let currentPin = "4321"
		let newPin = "1234"

		IngressKit.userService.change(pin: currentPin, newPin: newPin, completion: { (result) in
			
			switch result {
			case .failure(let error):	print(error.localizedDescription ?? "error")
			case .success:				print("success")
			}
		}, onSessionError: { (error) in
			LOG.E(Const.invalidSessionMessage + "\(error)")
        }, onWrongPinError: {
            LOG.E("Wrong Pin")
        })
	}
	
	@IBAction func deletePin(_ sender: Any) {
		
		let currentPin = "4321"
		IngressKit.userService.delete(pin: currentPin, completion: { (result) in
			
			switch result {
			case .failure(let error):	print(error.localizedDescription ?? "error")
			case .success:				print("success")
			}
		}, onSessionError: { (error) in
			LOG.E(Const.invalidSessionMessage + "\(error)")
        }, onWrongPinError: {
            LOG.E("Wrong Pin")
        })
	}
	
    @IBAction func showImageButtonTapped(_ sender: Any) {
        self.showImage()
    }
    
	@IBAction func uploadImageButtonTapped(_ sender: UIButton) {
		
        _ = MBImagePickerManager(viewController: self) { (image) in
            
            self.uploadImage(image: image)
        }
	}
	
	@IBAction func countriesButtonTapped(_ sender: Any) {
        self.loadCountries()
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        self.sendMessage()
    }
    
    @IBAction func profileFieldsButtonTapped(_ sender: Any) {
        self.fetchProfileFields()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.logout()
    }
    
    
    // MARK: - Ingress API
    
    func userExist() {
        
        IngressKit.userService.existUser(username: User.elonMusk) { (result) in
            
            switch result {
                
            case .failure(let error):
                LOG.E(error)
                
            case .success(let user):
                
                if user.username == "" {
                    
                    LOG.D("Users is not registered. Proceed with registration!")
                
                } else {
                    
                    LOG.D("User already registered. Pin should be sent via mail. Proceed with login")
                }
            }
        }
    }
    
    func login() {
        
        let pinFromMailOrSMS = "" // TODO: add pin here
        
		IngressKit.loginService.login(username: User.elonMusk, pin: pinFromMailOrSMS) { (result) in
            
            switch result {
            case .failure:
                LOG.E("login error)")
            case .success:
                LOG.D("login success")
            }
        }
    }
    
    func register() {
        let address = UserAddressModel(city: "city",
                                       countryCode: "countryCode",
                                       houseNo: "houseNo",
                                       state: "state",
                                       street: "street",
                                       zipCode: "zipCode",
                                       province: "province",
                                       doorNo: "doorNo",
                                       addressLine1: "addressLine1",
                                       streetType: "streetType",
                                       houseName: "houseName",
                                       floorNo: "floorNo",
                                       addressLine2: "addressLine2",
                                       addressLine3: "addressLine3",
                                       postOfficeBox: "postOfficeBox")
        
        let communicationPreference = UserCommunicationPreferenceModel(phone: nil, letter: nil, email: true, sms: true)
        
        let user = UserModel(address: address,
                             birthday: Date(),
                             ciamId: "",
                             createdAt: "",
                             email: "email@email.com",
                             firstName: "firstName",
                             lastName1: "lastName1",
                             lastName2: "lastName2",
                             landlinePhone: "landlinePhone",
                             mobilePhoneNumber: "mobilePhoneNumber",
                             updatedAt: "updatedAt",
                             accountCountryCode: "accountCountryCode",
                             userPinStatus: UserPinStatus.notSet,
                             communicationPreference: communicationPreference,
                             profileImageData: nil,
                             unitPreferences: UserUnitPreferenceModel(),
                             salutation: nil,
                             title: nil,
                             taxNumber: nil,
                             namePrefix: nil,
                             preferredLanguageCode: "en-GB",
                             middleInitial: nil,
                             accountIdentifier: nil,
                             adaptionValues: nil,
                             accountVerified: false)
        
		IngressKit.userService.create(user: user, completion: { (result) in
			
			switch result {
			case .failure(let error):	LOG.E(error)
			case .success(let user):	LOG.D(user)
			}
		}, onConflict: {
			LOG.D("conflict")
		})
    }
    
    func refreshToken() {
        
        IngressKit.loginService.refreshTokenIfNeeded(onComplete: { (token) in
            
            LOG.D(token)
            
        }, onError: { (error) in
            
            LOG.E(error)
        })
    }
    
    func fetchUser() {

        IngressKit.userService.fetchUser(completion: { (result) in
            switch result {
            case .success(let user):
                LOG.D(user)
                
            case .failure(let error):
                LOG.E(error)
            }
        }, onSessionError: { error in
            LOG.E(Const.invalidSessionMessage + "\(error)")
        })
    }
    
    func updateUser() {
        
        guard let currentUser = IngressKit.userService.validUser else {
            
            LOG.W("You have to fetch the user first")
            return
        }
        
        IngressKit.userService.update(user: currentUser, completion: { (result) in
            
            switch result {
            case .success(let user):
                LOG.D(user)
                
            case .failure(let error):
                LOG.E(error)
            }
        }, onSessionError: { error in
            LOG.E(Const.invalidSessionMessage + "\(error)")
        })
    }
    
    func showImage() {
        
        IngressKit.userService.fetchUserImage(completion: { (image) in
            
            if let image = image {
                self.imageView.image = image
            } else {
                LOG.E()
            }
        }, onSessionError: { error in
            LOG.E(Const.invalidSessionMessage + "\(error)")
        })
    }
    
    func uploadImage(image: UIImage) {
        
        guard let data = image.jpegData(compressionQuality: 0.3) else {
            return
        }
        
        IngressKit.userService.upload(data: data, completion: { (result) in
            
            switch result {
            case .failure(let error):
                LOG.E("upload error: \(error.localizedDescription ?? "")")
                
            case .progress(let fraction):
                LOG.V("upload progress: \(fraction)")
                
            case .success:
                self.showImage()
            }
        }, onSessionError: { error in
            LOG.E(Const.invalidSessionMessage + "\(error)")
        })
    }
    
    func loadCountries() {
        
        IngressKit.userService.countries { (result) in
            
            switch result {
                
            case .failure(let error):
                LOG.E(error)
                
            case .success(let countries):
                LOG.D(countries)
            }
        }
    }
    
    func sendMessage() {
        let assistanceMailModel = AssistanceMailModel(appName: "appName",
                                          language: "en-US",
                                          firstName: "firstName",
                                          lastName: "lastName",
                                          streetName: "streetName",
                                          streetNumber: "23",
                                          zipCode: "232334",
                                          city: "city",
                                          country: "country",
                                          phone: "+49213456789",
                                          customerEmail: "customerEmail@customerEmail.com",
                                          device: "iphone",
                                          os: "iOS",
                                          appVersion: "1.1.1",
                                          messageText: "messageText")


        IngressKit.userService.assistancemail(assistanceMailModel: assistanceMailModel) { (result) in
            
            switch result {
                
            case .failure(let error):
                LOG.E(error)
                
            case .success:
                LOG.D()
            }
        }
    }
	
    func fetchProfileFields() {
        IngressKit.userService.fetchProfileFields(countryCode: "US", locale: "en-US") { (result) in
            switch result {
                
            case .failure(let error):
                LOG.E(error)
                
            case .success(let profileFields):
                LOG.D(profileFields)
            }
        }
    }
    
    func logout() {
        
        IngressKit.loginService.logout { (result) in
            
            switch result {
            case .success:
                LOG.D()
                
            case .failure(let error):
                LOG.E(error)
            }
        }
    }
}
