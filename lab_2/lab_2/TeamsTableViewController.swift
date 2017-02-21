//
//  TeamsTableViewController.swift
//  lab_2
//
//  Created by Siddharth on 2/19/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class TeamsTableViewController: UITableViewController {
    
    var teamPlayer = TeamPlayers()
    
    var newFile = "newTeamPlayers.plist"
    
    var selectedTeam = String()
    var selectedPlayers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path: String?
        let filePath = loadFile(newFile) //Getting the path to the file
        
        //if the file exists, then use it
        if FileManager.default.fileExists(atPath: filePath)
        {
            path = filePath
        }
        else
        {
            path = loadOldFile()
        }
        
        //load the data of the plist file into the dictionary
        teamPlayer.teamAndPlayer = NSDictionary(contentsOfFile: path!) as! [String : [String]]
        //puts all the continents in an array
        teamPlayer.teams = Array(teamPlayer.teamAndPlayer.keys)
        
        //Need to add a listener for when a new country is added
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: app)
    }

    func applicationWillResignActive(_ notification: Notification){
        let filePath = loadFile(newFile)
        let data = NSMutableDictionary()
        //adds our whole dictionary to the data dictionary
        data.addEntries(from: teamPlayer.teamAndPlayer)
        //write the contents of the array to our plist file
        data.write(toFile: filePath, atomically: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadFile(_ file: String)->String
    {
        //Locate the documents directory
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = path[0] as NSString
        return dir.appendingPathComponent(file)

    }
    
    func loadOldFile()->String?
    {
        guard let pathString = Bundle.main.path(forResource: "teamPlayers", ofType: "plist")
        else
        {
            return nil
        }
        return pathString

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teamPlayer.teamAndPlayer.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = teamPlayer.teams[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeam = teamPlayer.teams[indexPath.row]
        selectedPlayers = teamPlayer.teamAndPlayer[selectedTeam]!
        self.performSegue(withIdentifier: "teamToPlayers", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "teamToPlayers")
        {
            let destinationVC = segue.destination as! PlayersTableViewController
            destinationVC.players = selectedPlayers
            destinationVC.team = selectedTeam
            destinationVC.teamPlayer = teamPlayer
        }
    }

}
