//
//  TableViewController.swift
//  lab_6
//
//  Created by Siddharth on 4/5/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var teamPlayerObject = [teamPlayer]()
    
    var selectedPlayerObject: teamPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
  
        ref = FIRDatabase.database().reference()
        
        ref.observe(FIRDataEventType.value, with: { snapshot in self.teamPlayerObject = []
            
            for i in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let newTeamPlayer = teamPlayer(snapshot: i)
                self.teamPlayerObject.append(newTeamPlayer)
            }
            self.tableView.reloadData()
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return teamPlayerObject.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = teamPlayerObject[indexPath.row].player

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayerObject = teamPlayerObject[indexPath.row]
        self.performSegue(withIdentifier: "tableToDetail", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            ref.child(teamPlayerObject[indexPath.row].player).removeValue()
        }
    }
    
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
    @IBAction func unwind(_ segue: UIStoryboardSegue)
    {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tableToDetail")
        {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.selectedPlayerObject = selectedPlayerObject
        }
    }
}
