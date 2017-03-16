//
//  AddViewController.swift
//  midterm
//
//  Created by Siddharth on 3/16/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var newData: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "doneAddToDetail", sender: self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "doneAddToDetail")
        {
            let destinationVC = segue.destination as! DataTableViewController
            if(newData.hasText)//Sending data only if user has entered some text
            {
                destinationVC.newData = newData.text
            }
            else
            {
                print("empty")
            }
        }
    }
}
