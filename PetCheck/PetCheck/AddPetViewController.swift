//
//  AddPetViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/14/21.
//

import UIKit

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
    
    
    //MARK: Variables
    
    //arrays
    var petTypes = ["Dog", "Cat", "Fish"]
    var dogActivities = ["Fed", "Walked", "Took Potty"]
    var catActivities = ["Fed", "Cleaned Litter Box"]
    var fishActivities = ["Fed", "Cleaned Bowl"]

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
    
    //MARK: Objects
    
    //MARK: Methods
    
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
