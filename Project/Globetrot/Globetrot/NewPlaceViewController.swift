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
    
    var new = Bool()// true indicates new place, false indicates existing place
    
    var place = Places()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToExtraNotes.backgroundColor = UIColor.orange
        goToExtraNotes.tintColor = UIColor.white
        mainNotes.layer.borderColor = UIColor.gray.cgColor
        mainNotes.layer.borderWidth = 0.5
        
        mainNotes.delegate = self
        placeName.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(new == false)
        {
            placeName.text = place.placeName
            mainNotes.text = place.mainNotes
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if(new == false)
        {
            editPlace()
        }
        else
        {
            addPlace()
        }
    }

    @IBAction func goToExtraNotesTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "newPlaceToExtra", sender: self)
    }
    
    func editPlace()
    {
        //re-writing the values. Updation has to happen inside a write block only
        try! realm.write {
            place.placeName = placeName.text!
            place.mainNotes = mainNotes.text!
        }
        showSavedAlert()
    }
    
    func addPlace()
    {
        place.placeName = placeName.text!
        place.mainNotes = mainNotes.text!
        place.extraNotes = ""
        place.placeImageName = ""
        
        try! realm.write {
            realm.add(place)
        }
        showSavedAlert()
    }
    
    func showSavedAlert()
    {
        //function to let user know that their information has been saved.
        let savedAlert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
        present(savedAlert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            savedAlert.dismiss(animated: true, completion: nil)
        }
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
    
}
