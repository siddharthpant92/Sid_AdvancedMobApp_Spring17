//
//  DetailViewController.swift
//  AdMobAppMidterm 3
//
//  Created by Siddharth on 3/15/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var continentList = MainClass()
    var selectedCountries = [String]()
    
    var newPlace = String()
    
    func configureView() {
        // Update the user interface for the detail item.
        if self.selectedContinent != nil {
            selectedCountries = continentList.continentCountry[selectedContinent!]!
         }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = selectedCountries[indexPath.row]
        
        return cell
    }
    
    var selectedContinent: String? {
        //didSet is like a listener. Detects when it's value was changed
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "detailToAdd", sender: self)
    }
    
    @IBAction func backToDetail(_ segue: UIStoryboardSegue)
    {
        let sourceVC = segue.source as! AddViewController
        newPlace = sourceVC.new
        selectedCountries.append(newPlace)
        tableView.reloadData()
        
        continentList.continentCountry[selectedContinent!]?.append(newPlace)
    }

}

