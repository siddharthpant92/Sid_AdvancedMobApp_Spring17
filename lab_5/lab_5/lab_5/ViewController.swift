//
//  ViewController.swift
//  lab_5
//
//  Created by Siddharth on 4/2/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getCoordinatesTapped(_ sender: Any) {
        let url = URL(string :"http://api.open-notify.org/iss-now.json")
        let session = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in

            do
            {
                // get json data
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                print(json)
                print()
                
                let position = json["iss_position"] as! [String:Any]
                DispatchQueue.main.async(execute: {
                    
                    self.latitudeLabel.text = "Latitude: \(position["latitude"]!)"
                    self.longitudeLabel.text = "Latitude: \(position["longitude"]!)"                })
            }
            catch
            {
                print("Error with JSON: \(error)")
                return
            }
        })
        //must call resume to run session
        session.resume()
    }
}

