//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Matthew Olker on 3/27/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: BorderedTextField!
    @IBOutlet var serialNumberField: BorderedTextField!
    @IBOutlet var valueField: BorderedTextField!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!

    var initialValue: Any!
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        
        
        //If the device has a camera, take a picture; otherwise,
        //just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let overlayView = UIImageView()
            
            overlayView.image = #imageLiteral(resourceName: "Untitled-1")
            
            imagePicker.cameraOverlayView = overlayView
            imagePicker.sourceType = .camera
            //imagePicker.cameraOverlayView
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        
        //Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func deletePicture(_ sender: UIBarButtonItem) {
        let image = UIImage()
        imageView.image = image
        self.imageStore.deleteImage(forKey: item.itemKey)
    }
    
    var imageStore: ImageStore!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        //Get picked image form info dictionary 
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        //Put the image on the screen in the image view
        imageView.image = image
        
        //Take image picker off the screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    var item: Item! {
        didSet {
            if item.name == "" {
                navigationItem.title = "Set a Name and Value"
            } else {
                navigationItem.title = item.name
            }
        }
    }
    @IBAction func textFieldChanged(_ sender: BorderedTextField) {
        if nameField.text != "" && valueField.text != String(describing: initialValue!) {
            navigationItem.setHidesBackButton(false, animated: true)
        }
        if nameField.text != "" {
            navigationItem.title = nameField.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if item.name == "" {
            navigationItem.setHidesBackButton(true, animated: true)
        }
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        initialValue = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        
        //Get the item key 
        let key = item.itemKey
        
        //If there is an associated image with the item
        //display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.setHidesBackButton(false, animated: true)
        
        //Clear first responder
        view.endEditing(true)
        
        //"Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "changeDate"?:
            navigationItem.setHidesBackButton(false, animated: true)
            //Get the item associated with this row and pass it along
            let dateViewController = segue.destination as! DateViewController
            dateViewController.item = item
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

}

