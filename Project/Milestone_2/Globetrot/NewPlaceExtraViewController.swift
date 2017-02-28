//
//  NewPlaceExtraViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/22/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class NewPlaceExtraViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goToPhoto: UIButton!
    @IBOutlet weak var textView2: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToPhoto.backgroundColor = UIColor.orange
        goToPhoto.tintColor = UIColor.white
        textView2.layer.borderColor = UIColor.gray.cgColor
        textView2.layer.borderWidth = 0.5
        
        textView2.delegate = self
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
    
    @IBAction func goToPhotosTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "extraToPhoto", sender: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
