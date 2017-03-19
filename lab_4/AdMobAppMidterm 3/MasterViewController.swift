//
//  MasterViewController.swift
//  AdMobAppMidterm 3
//
//  Created by Siddharth on 3/15/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate{

    
    var detailViewController: DetailViewController? = nil
    
    var continentList = MainClass()
    
    var path: String?
    var newFile = "data.plist"
        
    var selectedContinent = String()
    
    var searching: Bool = false
    
    var filteredPlaces = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        
       if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let newPath = getPath(newFile: newFile)
        if(FileManager.default.fileExists(atPath: newPath))
        {
            path = newPath
        }
        else
        {
            path = getOriginalFile()
        }
        
        continentList.continentCountry = NSDictionary(contentsOfFile: path!) as! [String: [String]]
        continentList.continent = Array(continentList.continentCountry.keys)
        
        //Need to add a listener for when a new country is added
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: app)
    }
    
    func getPath(newFile: String)->String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = path[0] as NSString
        return dir.appendingPathComponent(newFile)
    }

    func getOriginalFile()->String?
    {
        guard let pathString = Bundle.main.path(forResource: "continents", ofType: "plist")
            else
        {
            return nil
        }
        return pathString
    }
    
    func applicationWillResignActive(_ notification: Notification){
        let filePath = getPath(newFile: newFile)
        let data = NSMutableDictionary()
        //adds our whole dictionary to the data dictionary
        data.addEntries(from: continentList.continentCountry)
        //write the contents of the array to our plist file
        data.write(toFile: filePath, atomically: true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

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
            return continentList.continent.count
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if(searching == true)
        {
            cell.textLabel?.text = filteredPlaces[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = continentList.continent[indexPath.row]
        }

        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searching == true)
        {
            selectedContinent = filteredPlaces[indexPath.row]
        }
        else
        {
            selectedContinent = continentList.continent[indexPath.row]
        }
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedPlace = continentList.continent[indexPath.row]
            continentList.continent.remove(at: indexPath.row)
            continentList.continentCountry[deletedPlace] = nil
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
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
            filteredPlaces = []
            searching = true
            let newSearchText = searchText.lowercased()
            for i in continentList.continent
            {
                if((i.lowercased().range(of: newSearchText)) != nil)
                {
                    filteredPlaces.append(i)
                }
            }
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searching = false
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destination = segue.destination as! UINavigationController
            let destinationVC = destination.topViewController as! DetailViewController
            destinationVC.continentList = continentList
            destinationVC.selectedContinent = selectedContinent
            destinationVC.title = selectedContinent
            destinationVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            destinationVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }

}

















