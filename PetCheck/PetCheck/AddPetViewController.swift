//
//  AddPetViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/14/21.
//

import UIKit
import Firebase

class AddPetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Outlets
    
    //text fields
    @IBOutlet weak var petNameTF: UITextField!
    @IBOutlet weak var petDescriptionTF: UITextField!
    @IBOutlet weak var petSpecificNeedsTF: UITextField!
    
    //picker
    @IBOutlet weak var petTypePicker: UIPickerView!
    
    //text view
    @IBOutlet weak var activitiesTextView: UITextView!
    
    //buttons
    @IBOutlet weak var addPet: UIButton!
    
    
    //MARK: Variables
    
    //arrays
    var petTypes = ["Dog", "Cat", "Fish"]
    var dogActivities = ["Fed", "Walked", "Took Potty"]
    var catActivities = ["Fed", "Cleaned Litter Box"]
    var fishActivities = ["Fed", "Cleaned Bowl"]
    var tStamps = [Date]()
    
    //user and room
    var selectedRoom: Room!
    var currentUser: User!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Add New Pet"
        
        petTypePicker.delegate = self
        petTypePicker.dataSource = self
        
        var activeString = ""
        for act in dogActivities {
            activeString.append("\n- \(act)")
        }
        activitiesTextView.text = activeString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        petTypePicker.reloadAllComponents()
    }
    
    //MARK: Actions
    @IBAction func editingChangedTF(_ sender: UITextField) {
        
        CheckTF()
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    
    func CheckTF() {
        
        if petNameTF.text?.isEmpty == true || petDescriptionTF.text?.isEmpty == true || petSpecificNeedsTF.text?.isEmpty == true {
            
            addPet.isEnabled = false
        }
        else {
            
            addPet.isEnabled = true
        }
        
    }
    
    func SavePetProfileData(petName: String, petType: String, description: String, specificNeeds: String) {
        
        //set reamining variables not coming into func
        var activities = [String]()
        let timeNow = NSDate.now
        
        switch petType {
        case "Dog":
            activities = dogActivities
            tStamps.append(timeNow)
            
        case "Cat":
            activities = catActivities
        case "Fish":
            activities = fishActivities
        default:
            print("Issue setting activities - Add Pet View")
            
        }
        
        //set database
        let database = Firestore.firestore()
        
        //add document to collection
        database.collection("PetProfiles").addDocument(data: ["activities": activities, "creator": selectedRoom.creator, "description": description, "petName": petName, "petType": petType, "roomName": selectedRoom.name, "specificNeeds": specificNeeds, "tStamps": tStamps])
        
        
        
    }
    
    //MARK: Picker View Callbacks
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return petTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return petTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var activeString = ""
        
        switch petTypes[row] {
        case "Dog":
            for act in dogActivities {
                activeString.append("\n- \(act)")
            }
        case "Cat":
            for act in catActivities {
                activeString.append("\n- \(act)")
            }
        case "Fish":
            for act in fishActivities {
                activeString.append("\n- \(act)")
            }
        default:
            print("Error Settings Text View - Add Pet")
        }
        
        activitiesTextView.text = activeString
        
        
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
