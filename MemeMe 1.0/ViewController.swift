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
}

