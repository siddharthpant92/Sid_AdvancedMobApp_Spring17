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
    
    @IBOutlet weak var placeImageView: UIImageView?
    @IBOutlet weak var loadingLabel: UILabel!
    
    var place = Places()
    var placeName = String()//To store the name of place
    var mainNotes = String()//To store the main notes
    var extraNotes = String()//To store the extra notes
    var imageData = NSData()//The image data to be saved
    
    let picker = UIImagePickerController()
    
    var changeImage: Bool = false//To detect if a new image should be displayed
    var chosenImage: UIImage? = nil//Image selected from gallery
    var imagePresent = Bool()//To check if an image is being displayed or not
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = place.placeName
        loadingLabel.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(changeImage != true) //A new image hasn't been selected(after user selects the camera or library icon
        {
            if(place.image != nil) //An image was previously saved
            {
                placeImageView?.image = UIImage(data: place.image as! Data)
            }
        }
        else //Displaying new image
        {
            placeImageView?.image = chosenImage
        }
        
        if(placeImageView?.image != nil)
        {
            loadingLabel.isHidden = true
            imagePresent = true
        }
        else
        {
            imagePresent = false
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Selecting photo from the library
    @IBAction func libraryButtonTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    //Using the camera to take a photo
    @IBAction func cameraButtonTapped(_ sender: Any) {
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if(chosenImage != nil) //A new image has been selected and should be displayed
        {
            changeImage = true
        }
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        changeImage = false //A new image wasn't selected
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
      if (imagePresent == true)
        {
            let data = UIImageJPEGRepresentation((placeImageView?.image)!, 1)
            let compressedJPEGImage = UIImage(data: data!)
            if(picker.sourceType == .camera)//Saving the photo only if it was taken from the camera. Otherwise it already exists in the library
            {
                UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
            }
            
            save(data: data as NSData?)//Saving with image
            
            let savedAlert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
            present(savedAlert, animated: true, completion: nil)
            let delay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delay){
                savedAlert.dismiss(animated: true, completion: self.goBack)
            }
        }
        else if (imagePresent == false)
        {
            save(data: nil)//Saving without image
         
            let savedAlert = UIAlertController(title: "Saved", message: "Your entry has no image.", preferredStyle: .alert)
            present(savedAlert, animated: true, completion: nil)
            let delay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delay){
                savedAlert.dismiss(animated: true, completion: self.goBack)
            }
        }
        alreadySaved = true
    }
    
    
    @IBAction func deletePhtotoTapped(_ sender: Any) {
        placeImageView?.image = nil//Clearing the image
        loadingLabel.isHidden = false
        imagePresent = false
    }
    
    func save(data: NSData?)
    {
        if(alreadySaved == false)
        {
            //Adding a new object
            place.placeName = placeName
            place.mainNotes = mainNotes
            place.extraNotes = extraNotes
            place.image = data
            try! realm.write
            {
                    realm.add(place)
            }
        }
        else
        {
            //Editing the existing object
            try! realm.write
                {
                    place.image = data
                    place.extraNotes = extraNotes
                    place.placeName = placeName
                    place.mainNotes = mainNotes
            }
        }
    }
    
    func goBack()
    {
        self.performSegue(withIdentifier: "newPhotoToMyPlaces", sender: self)
    }
}














