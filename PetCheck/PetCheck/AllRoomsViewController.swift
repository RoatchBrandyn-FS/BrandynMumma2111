//
//  AllRoomsViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/5/21.
//

import UIKit
import Firebase

class AllRoomsViewController: UIViewController {
    
    //MARK: Outlets
    
    //views
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Variables
    
    //navigation buttons
    @IBOutlet weak var logoutBarBtn: UIBarButtonItem!
    
    //user
    var currentUser: User!
    
    //arrays
    var allRooms = [Room]()
    var searchRooms = [Room]()
    var userRooms = [Room]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Room Search"
        navigationItem.hidesBackButton = true
        tableView.layer.cornerRadius = 20
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReadRoomsDoc()
        
        print("\(allRooms.count.description) -> vwa")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("All Rooms Count: \(allRooms.count.description) -> vda")
        
        print("User Rooms Count: \(userRooms.count.description) -> vda")
        
    }
    
    //MARK: Actions
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    
    func ReadRoomsDoc(){
        
        //Clear lists
        allRooms.removeAll()
        userRooms.removeAll()
        
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
                            self.userRooms.append(newRoom)
                        }
                        
                        
                    })
                    
                    
                    
                }
                
                
            }
            
            else {
                print("Error occred loading firebase - All Rooms load")
            }
            
        }
        
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
