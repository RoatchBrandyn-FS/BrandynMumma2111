//
//  AllRoomsViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/5/21.
//

import UIKit
import Firebase

class AllRoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    //MARK: Outlets
    
    //views
    @IBOutlet weak var tableView: UITableView!
    
    //bar buttons
    @IBOutlet weak var logoutBarBtn: UIBarButtonItem!
    @IBOutlet weak var myRoomsBarBtn: UIBarButtonItem!
    
    //MARK: Variables
    
    //user
    var currentUser: User!
    
    //arrays
    var allRooms = [Room]()
    var sortedRooms = [Room]()
    
    //bools
    var userRoomOnly = true
    
    //search items
    var searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Rooms Lobby"
        navigationItem.hidesBackButton = true
        tableView.layer.cornerRadius = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        
        SearchSetup()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReadRoomsDoc()
        
        print("\(allRooms.count.description) -> vwa")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("All Rooms Count: \(allRooms.count.description) -> vda")
        
        print("User Rooms Count: \(sortedRooms.count.description) -> vda")
        
    }
    
    //MARK: Actions
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func myRoomsTapped(_ sender: UIBarButtonItem) {
        
        sortedRooms.removeAll()
        userRoomOnly = true
        
        for room in allRooms {
            if room.creator == currentUser.fullNameLF {
                sortedRooms.append(room)
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: Objects
    
    //MARK: Methods
    
    func ReadRoomsDoc(){
        
        //Clear lists
        allRooms.removeAll()
        sortedRooms.removeAll()
        
        //Set Database
        let database = Firestore.firestore()
        
        //Read documents for Rooms collection
        database.collection("Rooms").getDocuments { (snapshot, error) in
            
            //check errors
            if error == nil {
                
                //get all rooms and create obj for each
                
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (doc) in
                        
                        guard let creator = doc["creator"] as? String, let name = doc["name"] as? String, let password = doc["password"] as? String, let roomID = doc["roomID"] as? String
                        else{return}
                        
                        print(name)
                        
                        let newRoom = Room(name: name, creator: creator, roomID: roomID, password: password)
                        
                        print("---")
                        print("\(newRoom.name) obj in dispatch")
                        
                        self.allRooms.append(newRoom)
                        
                        if newRoom.creator == self.currentUser.fullNameLF {
                            self.sortedRooms.append(newRoom)
                        }
                        
                        
                    })
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
            else {
                print("Error occred loading firebase - All Rooms load")
            }
            
        }
        
    }
    
    func ReadPostsDocs() {
        
    }
    
    func ReadProfilesDocs() {
        
    }
    
    //MARK: Table View callbacks
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse identifier to cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "room_cell_01", for: indexPath)
        
        //Configure cells for either situation
        let room = sortedRooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        cell.detailTextLabel?.text = room.creator
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if userRoomOnly == true {
            return "My Rooms: \(sortedRooms.count.description)"
        }
        else {
            return "Search Results: \(sortedRooms.count.description)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    //MARK: Searchbar setup and Callbacks
    
    func SearchSetup() {
        
        //Setup
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        //updates set to our updater
        searchController.searchResultsUpdater = self
        
        //set searchbar
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Room Names", "Creators", "My Rooms"]
        
        //set to navigation
        navigationItem.searchController = searchController
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updated")
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("scope tapped")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked/tapped")
    }
    
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let s = sender as? UIBarButtonItem {
            
            if s.title == "Add Room" {
                
                let destination = segue.destination as? AddRoomViewController
                
                destination?.currentUser = currentUser
                
            }
            
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            print("Selected index: \(indexPath.description)")
            
            let roomToSend = sortedRooms[indexPath.row]
            
            print("\(roomToSend.name) before segue")
            
            if let destination = segue.destination as? TabbedViewController {
                print("\(roomToSend.name) in segue")
                destination.selectedRoom = roomToSend
            }
            
            
        }
        
    }
    

}
