//
//  TeamsTableViewController.swift
//  lab_2
//
//  Created by Siddharth on 2/19/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class TeamsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var teamPlayer = TeamPlayers()
    
    var newFile = "newTeamPlayers.plist"
    
    var selectedTeam = String()
    var selectedPlayers = [String]()
    
    var newTeam = String()
    
    var searching = Bool()
    
    var filteredTeams = [String]()
    
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
        
        filteredTeams = []
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Need to add a listener for when a new team is added
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: app)
        
        if(newTeam != "")
        {
            teamPlayer.teams.append(newTeam)
            teamPlayer.teamAndPlayer[newTeam] = []
            tableView.reloadData()
            
            //Reinitialising otherwise a new player can't be added to the new team since
            //the array of values for that newTeam will otherwise be reinitialised to empty all the time
            newTeam = ""
        }
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
        if(searching == true)
        {
            return filteredTeams.count
        }
        else
        {
            return teamPlayer.teamAndPlayer.count
        }
        
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(searching == true)
        {
            cell.textLabel?.text = filteredTeams[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = teamPlayer.teams[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searching == true)
        {
            selectedTeam = filteredTeams[indexPath.row]
            selectedPlayers = teamPlayer.teamAndPlayer[selectedTeam]!
            self.performSegue(withIdentifier: "teamToPlayers", sender: self)
        }
        else
        {
            selectedTeam = teamPlayer.teams[indexPath.row]
            selectedPlayers = teamPlayer.teamAndPlayer[selectedTeam]!
            self.performSegue(withIdentifier: "teamToPlayers", sender: self)
        }
    }
  
    @IBAction func backToTeams(_ segue: UIStoryboardSegue)
    {}
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let teamToBedDeleted = teamPlayer.teams[indexPath.row]
            teamPlayer.teams.remove(at: indexPath.row)
            teamPlayer.teamAndPlayer[teamToBedDeleted] = nil
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
            filteredTeams = []
            let newSearchText = searchText.lowercased()
            for i in teamPlayer.teams
            {
                if((i.lowercased().range(of: newSearchText)) != nil)
                {
                    filteredTeams.append(i)
                }
            }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
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
