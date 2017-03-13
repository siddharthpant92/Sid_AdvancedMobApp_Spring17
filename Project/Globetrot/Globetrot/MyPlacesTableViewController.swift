//
//  MyPlacesTableViewController.swift
//  Globetrot
//
//  Created by Siddharth on 2/18/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import RealmSwift

//Creating a global instance
var realm = try! Realm()

var alreadySaved: Bool = false //To check if information has already been saved once.

class MyPlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
}

class MyPlacesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var allPlaces = realm.objects(Places.self)
    var selectedPlace: Places? //The place the user selected
    
    var filteredPlaces = [Places]()//To store the filtered places details
    
    var searching = Bool()//To indicate whether user is searching and filtering places or not
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.orange//For bar color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]//For title color
        navigationController?.navigationBar.tintColor = UIColor.white//For bar buttons
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        refresh()//To display any changed data
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
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
        
        if(searching == true)//Displaying filtered places
        {
            cell.placeNameLabel?.text = filteredPlaces[indexPath.row].placeName
            if(filteredPlaces[indexPath.row].image != nil)
            {
                cell.placeImageView?.image = UIImage(data: filteredPlaces[indexPath.row].image as! Data)
            }
            else
            {
                cell.placeImageView?.image = UIImage(named: "delete")
            }
        }
        else//Displaying all places
        {
            cell.placeNameLabel?.text = allPlaces[indexPath.row].placeName
            if(allPlaces[indexPath.row].image != nil)
            {
                cell.placeImageView?.image = UIImage(data: allPlaces[indexPath.row].image as! Data)
            }
            else
            {
                cell.placeImageView?.image = UIImage(named: "delete")
            }
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alreadySaved = true//So that the details of the selected place are displayed
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            try! realm.write
            {
                realm.delete(allPlaces[indexPath.row])//Deleting place object
            }
            //Delete the row from the data table
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    @IBAction func backToMyPlaces(segue: UIStoryboardSegue) //Unwind segue from NewPhotoViewController
    {}
    
    @IBAction func addPlaceTapped(_ sender: Any) {
        alreadySaved = false //Allows the user to add new content for a new place
        self.performSegue(withIdentifier: "add_myPlaceToNewPlace", sender: self)
    }
    
    func refresh()
    {
        allPlaces = realm.objects(Places.self)
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
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
            for i in allPlaces//Traversing all places
            {
                if((i.placeName.lowercased().range(of: newSearchText)) != nil)//Checking if the text entered by user is a substring of any place name
                {
                    filteredPlaces.append(i)
                }
            }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)//Dismissing the keyboard
        searchBar.text = "" //Clearing search bar of any text
        searching = false //Shows unfiltered data
        tableView.reloadData()
        
        searchBar.showsCancelButton = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(alreadySaved == true) //Passing on details of selected place. If 'Add' button was tapped then there is nothing to pass on
        {
            let destinationVC = segue.destination as! NewPlaceViewController
            destinationVC.place = selectedPlace!
        }
    }
}
