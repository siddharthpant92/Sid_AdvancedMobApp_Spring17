//
//  NewPlaceExtraViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/22/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

class NewPlaceExtraViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goToPhoto: UIButton!
    @IBOutlet weak var extraNotes: UITextView!

    var place = Places()
    var saveTapped = Bool() //To check if save button was tapped
    var placeName = String() //To store the place name if not saved before
    var mainNotes = String()//To store the main notes if not saved before

    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToPhoto.backgroundColor = UIColor.orange
        goToPhoto.tintColor = UIColor.white
        extraNotes.layer.borderColor = UIColor.gray.cgColor
        extraNotes.layer.borderWidth = 0.5
        
        extraNotes.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        saveTapped = false
        
        print()
        print("extra = \(alreadySaved)")
        print()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveTapped = true
       
        if(alreadySaved == false)
        {
            place.placeName = placeName
            place.mainNotes = mainNotes
            place.image = nil
            place.extraNotes = extraNotes.text!
            try! realm.write {
                //Adding the new object
                realm.add(place)
            }
        }
        else
        {
            try! realm.write {
                //Editing the existing object
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
            // your code with delay
            savedAlert.dismiss(animated: true, completion: nil)
        }
        //Waiting for navigation stack to be updated
        sleep(1)

    }
    
    
    @IBAction func goToPhotosTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "add_extraToPhoto", sender: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! NewPhotoViewController
        destinationVC.place = place
//        if(saveTapped == false)
//        {
            destinationVC.placeName = placeName
            destinationVC.mainNotes = mainNotes
            destinationVC.extraNotes = extraNotes.text!
//        }
    }
}
