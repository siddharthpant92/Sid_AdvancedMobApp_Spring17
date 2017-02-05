//
//  openApplicationViewController.swift
//  lab1
//
//  Created by Siddharth on 2/4/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class openApplicationViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openAppStoreTapped(_ sender: Any) {
        if(UIApplication.shared.canOpenURL(URL(string: "itms-apps://")!))
        {
            UIApplication.shared.open(URL(string: "itms-apps://")!, options: [:], completionHandler: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Oops", message:
                "App Store can't be opened", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
   
}
