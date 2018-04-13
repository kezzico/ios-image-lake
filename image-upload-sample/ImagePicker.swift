//
//  ImagePicker.swift
//  image-upload-sample
//
//  Created by Lee Irvine on 4/12/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var completion = { (_: UIImage) in }
    private var parent: UIViewController!
    private var retainSelf:ImagePicker?
    private let imagePicker = UIImagePickerController()

    @discardableResult
    class func present(in presentingVc:UIViewController,  completion:@escaping (_: UIImage)->()) -> ImagePicker {
        let picker = ImagePicker()

        picker.retainSelf = picker
        picker.completion = completion
        picker.parent = presentingVc
        picker.showCamera()

        return picker
    }

    private func showCamera() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take photo from camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Take photo from photo album", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.parent.present(alert, animated: true, completion: nil)
    }

    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.showsCameraControls = true
            imagePicker.cameraDevice = .front

            self.parent.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.parent.present(alert, animated: true, completion: nil)
        }
    }

    private func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self

        self.parent.present(imagePicker, animated: true, completion: nil)
    }

    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        self.retainSelf = nil
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }

        self.imagePicker.dismiss(animated: false, completion: nil)
        self.completion(selectedImage)
        self.retainSelf = nil
    }
}
