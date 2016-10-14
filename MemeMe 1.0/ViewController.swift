//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Peter Khotpanya on 10/13/16.
//  Copyright © 2016 Peter Khotpanya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        
        // FIXME: Can't set defaultAttributedString either. Here we set the placeholder text with the text attributes.
        topTextView.attributedText = NSAttributedString.init(string: topTextView.text, attributes: memeTextAttributes)
        bottomTextView.attributedText = NSAttributedString.init(string: bottomTextView.text, attributes: memeTextAttributes)
        
        // FIXME: Changing the text also clears the center aligment set in the storyboard so we have to write it again.
        topTextView.textAlignment = NSTextAlignment.center
        bottomTextView.textAlignment = NSTextAlignment.center

        // FIXME: I can't use isEnabled from the UIBarButtonItem so I changed it through NSObject instead.
        cameraButton.setValue(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera), forKey: "enabled")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: View interface
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!

    @IBOutlet weak var shareActionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBAction func actionButtonPressed(_ sender: AnyObject) {
        
    }
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        
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
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text helper functions
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 1
    ] as [String : Any]
    
}

