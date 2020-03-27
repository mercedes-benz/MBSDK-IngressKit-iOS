//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit

public class MBImagePickerManager: NSObject, UINavigationControllerDelegate {
    
    // MARK: - Properties

    var picker: UIImagePickerController!
    var alert: UIAlertController!
    var viewController: UIViewController!
    var pickImageCallback: ((UIImage) -> Void)?
    
    
    // MARK: - Init
    
    deinit {
        LOG.V()
    }
    
    
    override private init() {
        super.init()
    }
    
    
    public convenience init(viewController: UIViewController, _ callback: @escaping (UIImage) -> Void) {

        self.init()
        self.viewController = viewController
        self.pickImageCallback = callback
        self.showAlert()
    }
    
    
    // MARK: - Alert & Picker
    
    func showAlert() {
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Bibliothek", style: .default) { _ in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.remove()
        }
        
        self.alert = UIAlertController(title: "Titel", message: nil, preferredStyle: .actionSheet)
        self.alert.addAction(cameraAction)
        self.alert.addAction(gallaryAction)
        self.alert.addAction(cancelAction)
        self.alert.popoverPresentationController?.sourceView = self.viewController.view
        self.viewController.present(self.alert, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        
        self.alert.dismiss(animated: true, completion: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            self.showPicker(sourceType: .camera)
            
        } else {
			
			
			self.alert = UIAlertController(title: "No Camera", message: nil, preferredStyle: .alert)
			self.viewController.present(alert, animated: true, completion: nil)
            self.remove()
        }
    }
    
    
    func openGallery() {
        
        self.alert.dismiss(animated: true, completion: nil)
        self.showPicker(sourceType: .photoLibrary)
    }
    
    
    func showPicker(sourceType: UIImagePickerController.SourceType) {
        
        self.picker = UIImagePickerController()
        self.picker.delegate = self
        self.picker.sourceType = sourceType
        self.viewController.present(self.picker, animated: true, completion: nil)
    }
    
    
    func remove() {
        
        self.picker = nil
        self.alert = nil
    }
}


// MARK: - UIImagePickerController Delegate

extension MBImagePickerManager: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        self.remove()
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            
            self.pickImageCallback?(image)
            self.remove()
        }
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        
        //
    }
}
