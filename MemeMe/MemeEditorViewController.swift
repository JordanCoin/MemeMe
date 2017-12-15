//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jordan Jackson on 10/12/17.
//  Copyright © 2017 Jordan Jackson. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIScrollViewDelegate {
    
    var imagePicker: UIImagePickerController!
    var selectedTextField: UITextField!
    var saveCancelButton: UIBarButtonItem!
    var memes: [Meme]!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var memeNavigationItem: UINavigationItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraOptionsToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Model methods
    
    @objc func save() {
        if memeUISet() {
            
            // Create the meme
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, orignialImage: memeImageView.image!, memeImage: generateMemedImage())

            // Add to memes array in application delegate
            MemeCollection.add(meme: meme)
            
            performSegue(withIdentifier: "unwindMemeEditor", sender: self)
        }
    }
    
    func memeUISet() -> Bool {
        if topTextField.text != nil || bottomTextField.text != nil || memeImageView.image != nil {
            // cancel button changes to save bar button
                // the selection function for the bar button will change between a cancel button and it's selection function and a save button and it's selection function
            return true
        } else {
            return false
        }
    }
    
    @objc func cancelTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    func topBarButtonActions() {
        // cancel button unwinds the view back to the controller
        // save button saves data and appends the memes object array
    }

    func generateMemedImage() -> UIImage {
        
        hideNavItems(hide: true)

        UIGraphicsBeginImageContextWithOptions(memeView.frame.size, memeView.isOpaque, 0.0)
        let context = UIGraphicsGetCurrentContext()
        memeView.layer.render(in: context!)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
            UIGraphicsEndImageContext()
        hideNavItems(hide: false)
        
        return memedImage
        
    }
    
    // MARK: - Configure UI
    
    func configureUI() {
        
        shareButton.isEnabled = false
        
        saveCancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTouched))
        memeNavigationItem.rightBarButtonItem = saveCancelButton
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configureTextFields([topTextField, bottomTextField])
    }
    
    func hideNavItems(hide: Bool) {
        
        navigationBar.isHidden = hide
//        navigationController?.navigationBar.isHidden = hide
        cameraOptionsToolbar.isHidden = hide
    }
    
    // MARK: - Button Actions
    
    @IBAction func takePhoto(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)

        activityController.completionWithItemsHandler = { (activityType: UIActivityType?, completion: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completion {
                self.save()
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
}

// MARK: - imagePicker delegate methods

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            shareButton.isEnabled = true
            saveCancelButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
            memeNavigationItem.rightBarButtonItem = saveCancelButton
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    
    // MARK: - Extesion for UITextFieldDelegate & Keyboard Notification methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        configureTextFields([topTextField, bottomTextField])
    }
    
    func configureTextFields(_ textFields: [UITextField]) {
        for textFields in textFields {
            
            textFields.delegate = self
            
            let memeTextAttributes: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey.strokeColor: UIColor.black,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.strokeWidth: -5.0]
            
            textFields.attributedText = NSAttributedString(string: textFields.text!, attributes: memeTextAttributes)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        selectedTextField.clearsOnInsertion = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selectedTextField = nil
        configureTextFields([textField])
        textField.resignFirstResponder()
        return true
    }
    
    // Mark: - Handling keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if selectedTextField == bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keybaordSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keybaordSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

}
