//
//  PhotoViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/22/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

class NewPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    var place = Places()
    var imageName = String()//The name of the image to be saved
    var placeName = String()//To store the name of place if not saved before
    var mainNotes = String()//To store the main notes if not saved before
    var extraNotes = String()//To store the extra notes if not saved before
    var alreadySaved = Bool()
    
    let picker = UIImagePickerController()
    var documentDirectory = String()
    var localPath = String()
    var imageData = NSData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func libraryButtonTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(picker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        placeImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if(placeImageView.image == nil)
        {
            let alert = UIAlertController(title: "Image missing!.", message:
                "Please select an image and then save.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let data = UIImageJPEGRepresentation(placeImageView.image!, 0.6)
        let compressedJPEGImage = UIImage(data: data!)
        if(picker.sourceType == .camera)
        {
            //Saving the photo only if it was taken from the camera. Otherwise it already exists in the library
            UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        }
        
        if(alreadySaved == false)
        {
          self.imageName = NSURL.fileURL(withPath: NSTemporaryDirectory() + placeName+"Image").lastPathComponent
        }
        else
        {
            self.imageName = NSURL.fileURL(withPath: NSTemporaryDirectory() + place.placeName+"Image").lastPathComponent
        }
        if(alreadySaved == false)
        {
            place.placeName = placeName
            place.mainNotes = mainNotes
            place.extraNotes = extraNotes
            place.image = data as NSData?
            try! realm.write {
                //Adding a new object
                realm.add(place)
            }
        }
        else
        {
            //Editing the existing object
            try! realm.write {
                place.image = data as NSData?
            }
        }

        let savedAlert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
        present(savedAlert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            savedAlert.dismiss(animated: true, completion: self.goBack)
        }
    }
    
    func goBack()
    {
        self.performSegue(withIdentifier: "newPhotoToMyPlaces", sender: self)
    }
}
