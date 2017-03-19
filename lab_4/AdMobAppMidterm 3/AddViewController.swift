//
//  AddViewController.swift
//  AdMobAppMidterm 3
//
//  Created by Siddharth on 3/15/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var NewPlace: UITextField!
    
    var new = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        new = NewPlace.text!
        self.performSegue(withIdentifier: "addToDetailSegue", sender: self)
    }

}
