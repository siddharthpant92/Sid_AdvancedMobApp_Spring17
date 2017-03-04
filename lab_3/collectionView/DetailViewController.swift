//
//  DetailViewController.swift
//  collectionView
//
//  Created by Siddharth on 2/21/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    var imageName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        detailImageView.image = UIImage(named: imageName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func shareButtonTapped(_ sender: Any) {
        //An array is needed because the parameter accepts only arrays. So need an array of size 1.
        var imageArray = [UIImage]()
        imageArray.append(detailImageView.image!)
        let shareScreen = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
        shareScreen.modalPresentationStyle = .popover
        shareScreen.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(shareScreen, animated: true, completion: nil)
    }

}
