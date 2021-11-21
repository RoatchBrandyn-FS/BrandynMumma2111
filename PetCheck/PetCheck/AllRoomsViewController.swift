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
    
    //MARK: Variables
    
    //user
    var currentUser: User!
    
    //arrays
    var allRooms = [Room]()
    var sortedRooms = [Room]()
    
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
        
    }
    
    //MARK: Actions
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
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
                        
                        let newRoom = Room(name: name, creator: creator, roomID: roomID, password: password, docID: doc.documentID)
                        
                        self.allRooms.append(newRoom)
                        
                        
                    })
                    
                    self.sortedRooms = self.allRooms
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
            else {
                print("Error occred loading firebase - All Rooms load")
            }
            
        }
        
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
        
        return "Search Results: \(sortedRooms.count.description)"
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let roomToSend = sortedRooms[indexPath.row]
        
        CheckCredentials(roomID: roomToSend.roomID, roomPassword: roomToSend.password, creator: roomToSend.creator, roomName: roomToSend.name)
        
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
        searchController.searchBar.scopeButtonTitles = ["Rooms By Name", "Rooms By Creator", "My Rooms"]
        
        //set to navigation
        navigationItem.searchController = searchController
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updated")
        
        //get searchBar text
        let searchText = searchController.searchBar.text
        
        //get scope button selected
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        let allScopeTitles = searchController.searchBar.scopeButtonTitles!
        let scopeTitle = allScopeTitles[selectedScope]
        
        // --- FIlter Search Content ---
        
        //set allRooms to sortedRooms for filtering
        sortedRooms = allRooms
        
        //filter text
        if searchText != "" {
            
            if scopeTitle == "Rooms By Name" {
                
                sortedRooms = sortedRooms.filter { (room) -> Bool in
                    return room.name.lowercased().range(of: searchText!.lowercased()) != nil
                }
                
            }
            
            else if scopeTitle == "Rooms By Creator" {
                
                sortedRooms = sortedRooms.filter { (room) -> Bool in
                    return room.creator.lowercased().range(of: searchText!.lowercased()) != nil
                }
                
            }
            
        }
        
        //filter on scope
        
        
        if scopeTitle == "My Rooms" {
            
            sortedRooms = sortedRooms.filter({
                
                $0.creator.range(of: currentUser.fullNameLF) != nil
                
            })
            
            if searchText != "" {
                
                sortedRooms = sortedRooms.filter { (room) -> Bool in
                    return room.name.lowercased().range(of: searchText!.lowercased()) != nil
                }
                
            }
            
        }
        
        
        //reload table
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
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
            
            let roomToSend = allRooms[indexPath.row]
            
            if let destination = segue.destination as? TabBarController {
                
                destination.selectedRoom = roomToSend
                destination.currentUser = currentUser
            }
            
            
        }
        
    }
    
    func CheckCredentials(roomID: String, roomPassword: String, creator: String, roomName: String) {
        
        //alert needs 2 buttons, and two text fields for roomID and password
        let roomAlert = UIAlertController(title: "Sign Into \(creator)'s Room: \(roomName)", message: "Please input the roomID and the Password for \(roomName)", preferredStyle: .alert)
        
        roomAlert.addTextField { (field) in
            field.placeholder = "Enter RoomID..."
            field.returnKeyType = .next
        }
        roomAlert.addTextField { (field) in
            field.placeholder = "Enter Password..."
            field.returnKeyType = .continue
            field.isSecureTextEntry = true
        }
        
        roomAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        roomAlert.addAction(UIAlertAction(title: "Open Room", style: .default, handler:{_ in
            //read text fields and match to values in roomToSend
            guard let fields = roomAlert.textFields, fields.count == 2 else {
                return
            }
            let idTF = fields[0]
            let passwordTF = fields[1]
            
            guard let id = idTF.text, !id.isEmpty, let password = passwordTF.text, !password.isEmpty
            else {
                
                let roomStatusAlert = UIAlertController(title: "Sorry...", message: "Not all required fields were filled.", preferredStyle: .alert)
                roomStatusAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(roomStatusAlert, animated: true, completion: nil)
                
                return
                
            }
            
            
            if roomID != id || roomPassword != password {
                
                let roomStatusAlert = UIAlertController(title: "Sorry...", message: "Either the RoomID or Password didn't match.", preferredStyle: .alert)
                roomStatusAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(roomStatusAlert, animated: true, completion: nil)
            }
            else {
                
                self.performSegue(withIdentifier: "SelectRoomToTabbed", sender: self.tableView.indexPathForSelectedRow)
            }
            
        }))
        
        present(roomAlert, animated: true, completion: nil)
        
        
    }
    

}
