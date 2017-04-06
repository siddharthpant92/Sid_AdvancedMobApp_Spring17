//
//  DetailViewController.swift
//  lab_6
//
//  Created by Siddharth on 4/5/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedPlayerObject: teamPlayer!
    
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        playerLabel.text = selectedPlayerObject.player
        teamLabel.text = selectedPlayerObject.team
        positionLabel.text = selectedPlayerObject.position
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

}
