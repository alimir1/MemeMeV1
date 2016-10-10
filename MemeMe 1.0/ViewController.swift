//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Abidi on 10/10/16.
//  Copyright © 2016 com.AliMir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let defaultTopText = "Top"
    let defaultBottomText = "Bottom"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.delegate = self
        bottomTextField.delegate = self
        
        configureMemeUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToObserverNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToObserverNotifications()
    }
    
    func subscribeToObserverNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeToObserverNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func configureMemeUI() {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
            ] as [String : Any]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        topTextField.text = defaultTopText
        bottomTextField.textAlignment = .center
        bottomTextField.text = defaultBottomText
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // move picture view when the keyboard shows
        if bottomTextField.isEditing {
            self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clear default text when user starts typing
        if textField == topTextField {
            if topTextField.text == defaultTopText {
                topTextField.text = ""
            }
        } else if textField == bottomTextField {
            if bottomTextField.text == defaultBottomText {
                bottomTextField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if user leaves a text field empty, text field text displays default text
        if textField == topTextField {
            if topTextField.text == "" {
                topTextField.text = defaultTopText
            }
        } else if textField == bottomTextField {
            if bottomTextField.text == "" {
                bottomTextField.text = defaultBottomText
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pickAnImageFromAlbum() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
    }
    
}

