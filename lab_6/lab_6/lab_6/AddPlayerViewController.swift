//
//  AddPlayerViewController.swift
//  lab_6
//
//  Created by Siddharth on 4/5/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import Firebase

class AddPlayerViewController: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var newPlayer: UITextField!
    @IBOutlet weak var newPlayerTeam: UITextField!
    @IBOutlet weak var newPlayerPosition: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        //let newPlayer = teamPlayer(newTeam: self.newPlayerTeam.text!, newPlayer: self.newPlayer.text!, newPosition: self.newPlayerPosition.text!)
        
        let newPlayerDetails = ["name": self.newPlayer.text!, "position": self.newPlayerPosition.text!, "team": self.newPlayerTeam.text!]
        
        let newChild = ref.child(self.newPlayer.text!)
        newChild.setValue(newPlayerDetails)
        
        self.performSegue(withIdentifier: "saveToTable", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
