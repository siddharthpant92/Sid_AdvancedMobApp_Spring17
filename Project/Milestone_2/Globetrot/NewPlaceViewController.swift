//
//  NewPlaceViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/22/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class NewPlaceViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var goToExtraNotes: UIButton!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var wherePlace: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToExtraNotes.backgroundColor = UIColor.orange
        goToExtraNotes.tintColor = UIColor.white
        textView1.layer.borderColor = UIColor.gray.cgColor
        textView1.layer.borderWidth = 0.5
        
        textView1.delegate = self
        wherePlace.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func goToExtraNotesTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToExtra", sender: self)
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
