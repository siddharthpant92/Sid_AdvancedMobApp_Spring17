//
//  MyPlacesTableViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/18/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

class MyPlacesTableViewController: UITableViewController {

    // Decider variable. Based on its value, either existing data is shown or no data is shown
    
    var allPlaces = realm.objects(Places.self)
    
    var selectedPlace: Places?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refresh()
        
        print()
        print()
        print(allPlaces.count)
        print(allPlaces)
        print()
        print()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = allPlaces[indexPath.row].placeName
        if(allPlaces[indexPath.row].image != nil)
        {
            cell.imageView?.image = UIImage(data: allPlaces[indexPath.row].image as! Data)
        }
        return cell
    }


//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        new = false
//        selectedPlace = allPlaces[indexPath.row] //To pass on the selected object
//        self.performSegue(withIdentifier: "myPlaceToNewPlace", sender: self)
//    }
//    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(allPlaces[indexPath.row])
            }
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    @IBAction func backToMyPlaces(segue: UIStoryboardSegue)
    {}
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPlaceTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "add_myPlaceToNewPlace", sender: self)
    }
    
    func refresh()
    {
        allPlaces = realm.objects(Places.self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "add_myPlaceToNewPlace")
        {
            alreadySaved = false
        }
    }
}
