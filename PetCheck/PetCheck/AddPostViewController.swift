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
        
        
        let tStamp = dateString()
        let replacedTStampNum = allPets[selectedPetRow].activities.firstIndex(of: selectedActivity!)
        
        print("\(allPets[selectedPetRow].petName) /  \(selectedActivity!) / \(currentUser.fullNameFL) / \(selectedRoom.creator) / \(selectedRoom.name) / \(tStamp)")
        allPets[selectedPetRow].tStamps.insert(tStamp, at: replacedTStampNum!)
        allPets[selectedPetRow].tStamps.remove(at: replacedTStampNum! + 1)
        
        SavePost(activity: selectedActivity!, creator: selectedRoom.creator, petName: allPets[selectedPetRow].petName, petType: allPets[selectedPetRow].petType, roomName: selectedRoom.name, tStamp: tStamp, user: currentUser.fullNameFL, row: selectedPetRow)
        
        navigationController?.popViewController(animated: true)
        
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
                        
                        print("Document ID: \(petProfile.documentID)")
                        
                        guard let creator = petProfile["creator"] as? String, let roomName = petProfile["roomName"] as? String
                        else {return}
                        
                        if creator == self.selectedRoom.creator && roomName == self.selectedRoom.name {
                            
                            guard let petName = petProfile["petName"] as? String, let petType = petProfile["petType"] as? String, let description = petProfile["description"] as? String, let specificNeeds = petProfile["specificNeeds"] as? String, let activities = petProfile["activities"] as? [String], let tStamps = petProfile["tStamps"] as? [String]
                            else{return}
                            
                            self.allPets.append(PetProfile(petName: petName, petType: petType, description: description, specificNeeds: specificNeeds, activities: activities, tStamps: tStamps, petProfileID: petProfile.documentID))
                            
                        }
                        
                    })
                    
                    self.petPicker.reloadAllComponents()
                    
                    print("All pets count: \(self.allPets.count)")
                    
                    if self.allPets.count == 0 {
                        let petAlert = UIAlertController(title: "Hold up...", message: "You must add a Pet Profile before you can post any activities.", preferredStyle: .alert)
                        
                        petAlert.addAction(UIAlertAction(title: "Back To Activity Posts", style: .default, handler: { (continue) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(petAlert, animated: true, completion: nil)
                    }
                    else {
                        self.petActivities = self.allPets[self.selectedPetRow].activities
                        self.activitiesTV.reloadData()
                        
                    }
                    
                }
                
            }
            else {
                print("Error occured loading firebase - All Pet Profiles load")
            }
        }
        
        
    }
    
    func dateString() -> String {
        
        let timestamp = NSDate.now
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let dString = formatter.string(from: timestamp)
        
        return "@\(dString)"
        
    }
    
    func SavePost(activity: String, creator: String, petName: String, petType: String, roomName: String, tStamp: String, user: String, row: Int) {
        
        //set database
        let database = Firestore.firestore()
        
        //add new doc for collection
        database.collection("Posts").addDocument(data: ["activity": activity, "creator": creator, "petName": petName, "petType": petType, "roomName": roomName, "tStamp": tStamp, "user": user ]) { (error) in
            //Check for errors
            
            if error == nil {
                //No Errors
                self.UpdatePetData(row: row)
                
            }
            else{
                //Deal with error(s)
                print("Error saving new post")
            }
        }
        
        
    }
    
    func UpdatePetData(row: Int) {
        
        // set database
        let database = Firestore.firestore()
        
        //get document refference
        let docRef = database.collection("PetProfiles").document(allPets[selectedPetRow].petProfileID)
        
        //update data
        docRef.updateData(["tStamps": allPets[selectedPetRow].tStamps])
        
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
