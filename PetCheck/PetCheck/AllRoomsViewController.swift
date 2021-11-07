//
//  AllRoomsViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/5/21.
//

import UIKit
import Firebase

class AllRoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Room Search"
        navigationItem.hidesBackButton = true
        tableView.layer.cornerRadius = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
