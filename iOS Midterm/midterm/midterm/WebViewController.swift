//
//  WebViewController.swift
//  midterm
//
//  Created by Siddharth on 3/16/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedResort: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if(selectedResort?.isEqual(to: "Aspen"))!
        {
            loadWebPage("https://www.aspensnowmass.com/")
            
        }
        else if(selectedResort?.isEqual(to: "Winter Park"))!
        {
            loadWebPage("https://www.snow.com/")
        }
        else if(selectedResort?.isEqual(to: "Eldora"))!
        {
            loadWebPage("https://www.eldora.com/")
        }
        else if(selectedResort?.isEqual(to: "Steamboat"))!
        {
            loadWebPage("https://www.steamboat.com/")
        }
    }
    
    func loadWebPage(_ urlString: String){
        print(urlString)
        //the urlString should be a propery formed url
        //creates a NSURL object
        let url = URL(string: urlString)
        print(url!)
        //create a NSURLRequest object
        let request = URLRequest(url: url!)
        print(request)
        //load the NSURLRequest object in our web view
        webView.loadRequest(request)
    }
    
    //UIWebViewDelegate method that is called when a web page begins to load
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("start load")
        webSpinner.startAnimating()
    }
    
    //UIWebViewDelegate method that is called when a web page loads successfully
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("stop load")
        webSpinner.stopAnimating()
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
