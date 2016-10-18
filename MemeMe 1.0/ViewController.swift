//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Peter Khotpanya on 10/13/16.
//  Copyright © 2016 Peter Khotpanya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeNavigationBar: UINavigationBar!
    @IBOutlet weak var memeToolbar: UIToolbar!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareActionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextfieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextfieldConstraint: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    var currentTextField: Int = 0
    var currentMemeImage: UIImage!
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1
        ] as [String : Any]

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        
        configure(textfield: topTextField)
        configure(textfield: bottomTextField)
        
        // Changing the text also clears the center aligment set in the storyboard so we have to write it again.
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        shareActionButton.isEnabled = false
        
        // Add observer for device rotation move the textfield farther apart in landscape
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: View interface
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        currentMemeImage = generateMemedImage()
        let activityVC = UIActivityViewController.init(activityItems: [currentMemeImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (activityType, completion, returnedItems, error) in
            if completion {
                self.saveMeme()
            }
        }
        
        present(activityVC, animated: true)
    }
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        clearMemeEditor()
    }
    @IBAction func cameraButtonPressed(_ sender: AnyObject) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func albumButtonPressed(_ sender: AnyObject) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Image helper functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        shareActionButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text style and helper functions
    func configure(textfield: UITextField ){
        textfield.defaultTextAttributes = memeTextAttributes
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        currentTextField = textField.tag
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard helper functions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if currentTextField == 101 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if currentTextField == 101 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Create Meme object functions
    func saveMeme() {
        //Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memeImage: currentMemeImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as!
            AppDelegate).memes.append(meme)
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        memeNavigationBar.isHidden = true
        memeToolbar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        memeNavigationBar.isHidden = false
        memeToolbar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Clear editor helper function
    func clearMemeEditor(){
        shareActionButton.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeImageView.image = nil
        currentMemeImage = nil
    }
    
    // MARK: Adjust the textfields on landscape
    func rotated(_ notification: NSNotification){
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print("landscape")
            topTextfieldConstraint.constant = 5
            bottomTextfieldConstraint.constant = 5
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print("Portrait")
            topTextfieldConstraint.constant = 28
            bottomTextfieldConstraint.constant = 40
        }
    }
    
}

