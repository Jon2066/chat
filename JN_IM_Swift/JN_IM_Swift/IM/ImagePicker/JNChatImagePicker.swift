//
//  JNChatImagePicker.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2020/2/11.
//  Copyright © 2020 Jonathan. All rights reserved.
//

import Foundation
import UIKit

enum JNChatImagePickerType {
    case photo
    case camera
}

class JNChatImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak private var rootController:UIViewController?
    
    var callback:((UIImage)->())?
     
    init(rootController: UIViewController){
        super.init()
        self.rootController = rootController
    }
    
    public func showImagePicker(type:JNChatImagePickerType, completion:@escaping (UIImage)->()){
        self.callback = completion
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        if type == .photo {
            imagePicker.modalPresentationStyle = .currentContext
            imagePicker.sourceType = .savedPhotosAlbum
        }
        else if type == .camera {
            imagePicker.videoQuality = .typeMedium
            imagePicker.sourceType = .camera
        }
        self.rootController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originImage = info[.originalImage]
        if picker.sourceType == .camera && originImage != nil {
            UIImageWriteToSavedPhotosAlbum(originImage as! UIImage, nil, nil, nil)
        }
        weak var weakSelf = self
        self.rootController?.dismiss(animated: true, completion: {
            if weakSelf?.callback != nil {
                weakSelf?.callback!(originImage as! UIImage)
            }
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.rootController?.dismiss(animated: true, completion: nil)
    }
}
