//
//  SettingsViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/18/21.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var settingsTV: UITableView!
    
    //MARK: Variables
    
    //arrays
    let creatorSettings = ["Leave Room", "Logout", "Delete Room"]
    let userSettings = ["Leave Room", "Logout"]
    
    //user and room
    var selectedRoom: Room!
    var currentuser: User!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tabbar = tabBarController as! TabBarController
        
        selectedRoom = tabbar.selectedRoom
        currentuser = tabbar.currentUser
        
        settingsTV.delegate = self
        settingsTV.dataSource = self
        
    }
    
    //MARK: Actions
    
    //MARK: Objects
    
    //MARK: Methods
    
    func LeaveRoom() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func Logout() {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func DeleteAlertWarning() {
        
        let deleteALert = UIAlertController(title: "WARNING", message: "This will Delete the entire room and all other data stored here. Are you sure you want to delete the room \(selectedRoom.name)?", preferredStyle: .alert)
        
        deleteALert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteALert.addAction(UIAlertAction(title: "Delete Profile", style: .destructive, handler: { (delete) in
            
            print("Should delete Room, Profiles, and Posts for this Room")
            
            DispatchQueue.main.async {
                self.ReadRoomPosts()
                self.ReadRoomPetProfiles()
                self.DeleteRoom()

                self.navigationController?.popViewController(animated: true)
            }
            
        }))
        
        present(deleteALert, animated: true, completion: nil)
        
    }
    
    func DeleteRoom() {
        
        //set database
        let database = Firestore.firestore()
        
        //get doc refference
        let docRef = database.collection("Rooms").document(selectedRoom.docID)
        
        //delete doc
        docRef.delete()
        
    }
    
    func ReadRoomPosts() {
        
        var posts = [Post]()
        
        //set database
        let database = Firestore.firestore()
        
        //read document for posts
        database.collection("Posts").getDocuments { (snapshot, error) in
            
            if error == nil {
                
                //Get posts and orgianize based on selected room
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (post) in
                        
                        guard let creator = post["creator"] as? String, let roomName = post["roomName"] as? String
                        else {return}
                        
                        if creator == self.selectedRoom.creator && roomName == self.selectedRoom.name {
                            
                            guard let activity = post["activity"] as? String, let petName = post["petName"] as? String, let petType = post["petType"] as? String, let tStamp = post["tStamp"] as? String, let user = post["user"] as? String
                            else {return}
                            
                            posts.append(Post(activity: activity, petName: petName, petType: petType, tStamp: tStamp, user: user, creator: creator, roomName: roomName, postID: post.documentID))
                            
                            
                        }
                        
                    })
                    
                    for post in posts {
                        
                        //set database
                        let database = Firestore.firestore()
                        
                        //get doc refference
                        let docRef = database.collection("Posts").document(post.postID)
                        
                        //delete doc
                        docRef.delete()
                        
                    }
                    
                }
                
                
            }
            else {
                print("Error occured loading firebase - All Posts load")
            }
            
        }
        
    }
    
    func ReadRoomPetProfiles() {
        
        var petProfiles = [PetProfile]()
        
        //set database
        let database = Firestore.firestore()
        
        //read documents for pet profiles
        database.collection("PetProfiles").getDocuments { (snapshot, error) in
            
            if error == nil {
                
                //Get pet profiles and organize bsaed on selected room
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (petProfile) in
                        
                        guard let creator = petProfile["creator"] as? String, let roomName = petProfile["roomName"] as? String
                        else {return}
                        
                        if creator == self.selectedRoom.creator && roomName == self.selectedRoom.name {
                            
                            guard let petName = petProfile["petName"] as? String, let petType = petProfile["petType"] as? String, let description = petProfile["description"] as? String, let specificNeeds = petProfile["specificNeeds"] as? String, let activities = petProfile["activities"] as? [String], let tStamps = petProfile["tStamps"] as? [String]
                            else{return}
                            
                            petProfiles.append(PetProfile(petName: petName, petType: petType, description: description, specificNeeds: specificNeeds, activities: activities, tStamps: tStamps, petProfileID: petProfile.documentID))
                            
                            
                        }
                        
                    })
                    
                    for petProfile in petProfiles {
                        
                        //set database
                        let database = Firestore.firestore()
                        
                        //get doc refference
                        let docRef = database.collection("PetProfiles").document(petProfile.petProfileID)
                        
                        //delete doc
                        docRef.delete()
                        
                    }
                    
                }
                
            }
            else {
                print("Error occured loading firebase - All Pet Profiles load")
            }
        }
        
    }
    
    
    
    
    
    //MARK: Tableview callbacks
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentuser.fullNameLF == selectedRoom.creator {
            return creatorSettings.count
        }
        else {
            return userSettings.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse id
        let cell = settingsTV.dequeueReusableCell(withIdentifier: "setting_cell_01", for: indexPath)
        
        //configure cell
        var setting = ""
        
        if currentuser.fullNameLF == selectedRoom.creator {
            setting = creatorSettings[indexPath.row]
            
        }
        else {
            setting = userSettings[indexPath.row]
        }
        
        cell.textLabel?.text = setting
        
        switch setting {
        case "Leave Room":
            cell.imageView?.image = UIImage.init(systemName: "arrowshape.turn.up.left")
        case "Logout":
            cell.imageView?.image = UIImage.init(systemName: "arrowshape.turn.up.left.2")
        case "Delete Room":
            cell.imageView?.image = UIImage.init(systemName: "xmark.square")
            cell.textLabel?.textColor = UIColor.red
            cell.tintColor = UIColor.red
        default:
            print("Error setting table view - Settings tab")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Settings"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var settingChoice = ""
        
        if currentuser.fullNameLF == selectedRoom.creator {
            settingChoice = creatorSettings[indexPath.row]
            
        }
        else {
            settingChoice = userSettings[indexPath.row]
            
        }
        
        switch settingChoice {
        case "Leave Room":
            print("Should Leave Room")
            LeaveRoom()
        case "Logout":
            print("Should logout to first view")
            Logout()
        case "Delete Room":
            print("Should delete room, and return to All Rooms View")
            DeleteAlertWarning()
        default:
            print("Error choosing settings option")
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
