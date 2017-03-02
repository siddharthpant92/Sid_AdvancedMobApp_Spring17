//
//  NewPlaceViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/22/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

class NewPlaceViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var goToExtraNotes: UIButton!
    @IBOutlet weak var mainNotes: UITextView!
    @IBOutlet weak var placeName: UITextField!
    
    var place = Places()
    var saveTapped = Bool() //To check whether save button was tapped or not
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToExtraNotes.backgroundColor = UIColor.orange
        goToExtraNotes.tintColor = UIColor.white
        mainNotes.layer.borderColor = UIColor.gray.cgColor
        mainNotes.layer.borderWidth = 0.5
        
        mainNotes.delegate = self
        placeName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //Unless the user taps save button, every other time it should be false
        saveTapped = false
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveTapped = true

        place.placeName = placeName.text!
        place.mainNotes = mainNotes.text!
        place.extraNotes = ""
        place.image = nil
        
        try! realm.write {
            realm.add(place)
        }
        
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

    
    @IBAction func goToExtraNotesTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "add_newPlaceToExtra", sender: self)
    }
    
    
    //Hides the keyboard on pressing return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! NewPlaceExtraViewController
        destinationVC.place = place
        if(saveTapped == false)
        {
            destinationVC.placeName = placeName.text!
            destinationVC.mainNotes = mainNotes.text!
            destinationVC.alreadySaved = false
        }
        else
        {
            destinationVC.alreadySaved = true
        }
    }
}
