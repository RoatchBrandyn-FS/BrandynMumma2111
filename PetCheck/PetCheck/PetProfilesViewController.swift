//
//  PetProfilesViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import UIKit
import Firebase

class PetProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    
    //views
    @IBOutlet weak var petProfilesTV: UITableView!
    
    //MARK: Variables
    
    //arrays
    var allPets = [PetProfile]()
    var allCats = [PetProfile]()
    var allDogs = [PetProfile]()
    var allFishes = [PetProfile]()
    var sortedPets = [[PetProfile]]()
    
    //room
    var selectedRoom: Room!
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tabbar = tabBarController as! TabBarController
        selectedRoom = tabbar.selectedRoom
        currentUser = tabbar.currentUser
        
        petProfilesTV.delegate = self
        petProfilesTV.dataSource = self
        petProfilesTV.layer.cornerRadius = 20
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReadPetProfiles()
        
    }
    
    //MARK: Methods
    
    func ReadPetProfiles() {
        
        //clear lists
        allPets.removeAll()
        allCats.removeAll()
        allDogs.removeAll()
        allFishes.removeAll()
        sortedPets.removeAll()
        
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
                            
                            self.allPets.append(PetProfile(petName: petName, petType: petType, description: description, specificNeeds: specificNeeds, activities: activities, tStamps: tStamps, petProfileID: petProfile.documentID))
                            
                            
                        }
                        
                    })
                    
                    for pet in self.allPets {
                        switch pet.petType {
                        case "Dog":
                            self.allDogs.append(pet)
                        case "Cat":
                            self.allCats.append(pet)
                        case "Fish":
                            self.allFishes.append(pet)
                        default:
                            print("Error sorting pets")
                        }
                    }
                    
                    self.sortedPets = [self.allDogs, self.allCats, self.allFishes]
                    self.petProfilesTV.reloadData()
                    
                }
                
            }
            else {
                print("Error occured loading firebase - All Pet Profiles load")
            }
        }
        
    }
    
    
    //MARK: Tableview callbacks
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sortedPets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPets[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse id
        let cell = petProfilesTV.dequeueReusableCell(withIdentifier: "pet_cell_01", for: indexPath)
        
        //cell configure
        let pet = sortedPets[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = pet.petName
        
        switch pet.petType {
        
        case "Dog":
            cell.imageView?.image = UIImage.init(named: "dogIcon")
        case "Cat":
            cell.imageView?.image = UIImage.init(named: "catIcon")
        case "Fish":
            cell.imageView?.image = UIImage.init(named: "fishIcon")
        default:
            print("Error loading image - Pet Profile Cells")
        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let listSection = sortedPets[section]
        
        switch section {
        case 0:
            return "My Dogs: \(listSection.count.description)"
        case 1:
            return "My Cats: \(listSection.count.description)"
        case 2:
            return "My Fishes: \(listSection.count.description)"
        default:
            return "Error laoding header for pet profiles"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let indexPath = petProfilesTV.indexPathForSelectedRow {
            print(indexPath)
            
            let petToSend = sortedPets[indexPath.section][indexPath.row]
            
            if let destination = segue.destination as? SinglePetViewController {
                
                destination.selectedPet = petToSend
                destination.selectedRoom = selectedRoom
                destination.currentUser = currentUser
                
            }
            
        }
            
            /*let destination = segue.destination as? AddPetViewController {
            
            destination.currentUser = currentUser
            destination.selectedRoom = selectedRoom
            
        }*/
        
    }
    
}
