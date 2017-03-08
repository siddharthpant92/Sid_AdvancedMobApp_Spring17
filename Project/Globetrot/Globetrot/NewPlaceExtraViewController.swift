//
//  NewPlaceExtraViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/22/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

class NewPlaceExtraViewController: UIViewController {

    @IBOutlet weak var goToPhoto: UIButton!
    @IBOutlet weak var extraNotes: UITextView!

    var place = Places()

    var placeName = String() //To store the place name if not saved before
    var mainNotes = String()//To store the main notes if not saved before

    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToPhoto.backgroundColor = UIColor.orange
        goToPhoto.tintColor = UIColor.white
        extraNotes.layer.borderColor = UIColor.gray.cgColor
        extraNotes.layer.borderWidth = 0.5
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        if(place.extraNotes != "")
        {
            extraNotes.text = place.extraNotes
        }
    }
    
   @IBAction func saveButtonTapped(_ sender: Any) {
        
        if(alreadySaved == false)//Adding the new object
        {
            place.placeName = placeName
            place.mainNotes = mainNotes
            place.image = nil
            place.extraNotes = extraNotes.text!
            try! realm.write
            {
                realm.add(place)
            }
        }
        else//Editing the existing object
        {
            //If the user had previously saved, the same values are simply over-written
            try! realm.write
            {
                place.extraNotes = extraNotes.text!
                place.placeName = placeName
                place.mainNotes = mainNotes
            }
        }
        alreadySaved = true
        
        let savedAlert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
        present(savedAlert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            savedAlert.dismiss(animated: true, completion: nil)
        }
    
        self.hideKeyboardWhenTappedAround()
    
        //Waiting for navigation stack to be updated
        sleep(1)
    }
    
    @IBAction func goToPhotosTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "add_extraToPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewPhotoViewController
        destinationVC.place = place
        destinationVC.placeName = placeName
        destinationVC.mainNotes = mainNotes
        destinationVC.extraNotes = extraNotes.text!
    }
}
