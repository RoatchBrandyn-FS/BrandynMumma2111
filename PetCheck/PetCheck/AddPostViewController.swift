//
//  AddPostViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/13/21.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    
    //pickers
    @IBOutlet weak var petPicker: UIPickerView!
    
    //buttons
    @IBOutlet weak var postBtn: UIButton!
    
    //tables
    @IBOutlet weak var activitiesTV: UITableView!
    
    //MARK: Variables
    
    //room
    var selectedRoom: Room!
    var currentUser: User!
    
    //arrays
    var allPets = [PetProfile]()
    var petActivities = [String]()
    
    //selections
    var selectedPetRow = 0
    var selectedActivity: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Add New Post"
        
        petPicker.delegate = self
        petPicker.dataSource = self
        
        activitiesTV.delegate = self
        activitiesTV.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReadPetProfileDocs()
    }
    
    //MARK: Actions
    @IBAction func postTapped(_ sender: UIButton) {
        
        let timestamp = NSDate.now
        
        print("\(allPets[selectedPetRow].petName) /  \(selectedActivity!) / \(currentUser.fullNameFL) / \(selectedRoom.creator) / \(selectedRoom.name) / \(timestamp)")
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    
    func ReadPetProfileDocs() {
        
        //clear lists
        allPets.removeAll()
        
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
                            
                            guard let petName = petProfile["petName"] as? String, let petType = petProfile["petType"] as? String, let description = petProfile["description"] as? String, let specificNeeds = petProfile["specificNeeds"] as? String, let activities = petProfile["activities"] as? [String], let timeStamps = petProfile["tStamps"] as? [Timestamp]
                            else{return}
                            
                            if timeStamps.count == 0 {
                                
                                self.allPets.append(PetProfile(petName: petName, petType: petType, description: description, specificNeeds: specificNeeds, activities: activities))
                                
                            }
                            else{
                                
                                var tStamps = [Date]()
                                for ts in timeStamps {
                                    
                                    tStamps.append(ts.dateValue())
                                    
                                }
                                
                                self.allPets.append(PetProfile(petName: petName, petType: petType, description: description, specificNeeds: specificNeeds, activities: activities, tStamps: tStamps))
                                
                            }
                            
                            
                            
                        }
                        
                    })
                    
                    self.petPicker.reloadAllComponents()
                    self.petActivities = self.allPets[self.selectedPetRow].activities
                    self.activitiesTV.reloadData()
                    
                }
                
            }
            else {
                print("Error occured loading firebase - All Pet Profiles load")
            }
        }
        
        
    }
    
    //MARK: Picker View Callbacks
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allPets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allPets[row].petName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedActivity = nil
        postBtn.isEnabled = false
        selectedPetRow = row
        petActivities = allPets[selectedPetRow].activities
        activitiesTV.reloadData()
        
    }
    
    //MARK: TableView Callbacks
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petActivities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse id
        let cell = activitiesTV.dequeueReusableCell(withIdentifier: "activity_cell_01", for: indexPath)
        
        //cell configure
        let activity = petActivities[indexPath.row]
        
        cell.textLabel?.text = activity
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Activities"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedActivity = petActivities[indexPath.row]
        
        if selectedActivity != nil {
            postBtn.isEnabled = true
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
