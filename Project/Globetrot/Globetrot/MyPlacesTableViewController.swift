//
//  MyPlacesTableViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/18/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

var alreadySaved: Bool = false //To check if information has already been saved once.

class MyPlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
}

class MyPlacesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var allPlaces = realm.objects(Places.self)
    var selectedPlace: Places?
    
    var filteredPlaces = [Places]() //To store the filtered places details
    
    var searching = Bool() //To indicate whether user is searching for a place
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refresh()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching == true)
        {
            return filteredPlaces.count
        }
        else
        {
            return allPlaces.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPlaceCell
        
        if(searching == true)
        {
            cell.placeNameLabel?.text = filteredPlaces[indexPath.row].placeName
            if(filteredPlaces[indexPath.row].image != nil)
            {
                cell.placeImageView?.image = UIImage(data: filteredPlaces[indexPath.row].image as! Data)
            }
        }
        else
        {
            cell.placeNameLabel?.text = allPlaces[indexPath.row].placeName
            if(allPlaces[indexPath.row].image != nil)
            {
                cell.placeImageView?.image = UIImage(data: allPlaces[indexPath.row].image as! Data)
            }
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alreadySaved = true
        
        //To pass on the selected object
        if(searching == true)
        {
            selectedPlace = filteredPlaces[indexPath.row]
        }
        else
        {
            selectedPlace = allPlaces[indexPath.row]
        }
        self.performSegue(withIdentifier: "add_myPlaceToNewPlace", sender: self)
    }
    
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
        alreadySaved = false
        self.performSegue(withIdentifier: "add_myPlaceToNewPlace", sender: self)
    }
    
    func refresh()
    {
        allPlaces = realm.objects(Places.self)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            searching = false
            tableView.reloadData()
        }
        else
        {
            searching = true
            filteredPlaces = []
            let newSearchText = searchText.lowercased()
            for i in allPlaces
            {
                if((i.placeName.lowercased().range(of: newSearchText)) != nil)
                {
                    filteredPlaces.append(i)
                }
            }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(alreadySaved == true)
        {
            let destinationVC = segue.destination as! NewPlaceViewController
            destinationVC.place = selectedPlace!
        }
    }
}
