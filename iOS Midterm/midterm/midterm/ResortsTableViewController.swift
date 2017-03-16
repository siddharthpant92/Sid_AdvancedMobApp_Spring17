//
//  ResortsTableViewController.swift
//  midterm
//
//  Created by Siddharth on 3/16/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class ResortsTableViewController: UITableViewController {
    
    var resortDataObject = ResortsData()
    
    var path: String? //The path of the file
    var newFile = "data.plist"//The new file

    var selectedResort = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newPath = getPath(newFile: newFile)
        
        if(FileManager.default.fileExists(atPath: newPath))
        {
            path = newPath
        }
        else
        {
            path = getOriginalFile()
        }
        resortDataObject.resortData = NSDictionary(contentsOfFile: path!) as! [String: [String]]
        resortDataObject.resorts = Array(resortDataObject.resortData.keys)
        
        
        let app = UIApplication.shared
        //Adding a listener UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: app)

    }

    // MARK: - Getting file path information
    func getPath(newFile: String)->String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = path[0] as NSString
        return dir.appendingPathComponent(newFile)
    }
    
    func getOriginalFile()->String?
    {
        guard let pathString = Bundle.main.path(forResource: "Resorts", ofType: "plist")
            else
        {
            return nil
        }
        return pathString
    }
    
    //Called when the UIApplicationWillResignActiveNotification notification is posted
    //All notification methods take a single NSNotification instance as their argument
    func applicationWillResignActive(_ notification: Notification)
    {
        let filePath = getPath(newFile: newFile)
        let data = NSMutableDictionary()
        //adds our whole dictionary to the data dictionary
        data.addEntries(from: resortDataObject.resortData)
        //write the contents of the array to our plist file
        data.write(toFile: filePath, atomically: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resortDataObject.resorts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = resortDataObject.resorts[indexPath.row]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedResort = resortDataObject.resorts[indexPath.row]
        self.performSegue(withIdentifier: "resortsToData", sender: self)
    }

    //On clicking the detail button
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        selectedResort = resortDataObject.resorts[indexPath.row]
        self.performSegue(withIdentifier: "resortsToWebView", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "resortsToData")
        {
            let destinationVC = segue.destination as! DataTableViewController
            destinationVC.resortDataObject = resortDataObject
            destinationVC.selectedResort = selectedResort
        }
        else if(segue.identifier == "resortsToWebView")
        {
            let destinationVC = segue.destination as! WebViewController
            destinationVC.selectedResort = selectedResort as AnyObject?
            
            destinationVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            destinationVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    

}
