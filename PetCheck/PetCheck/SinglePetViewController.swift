//
//  SinglePetViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/14/21.
//

import UIKit
import Firebase

class SinglePetViewController: UIViewController {
    
    //MARK: Outlets
    
    //text views
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var specificNeedsTextView: UITextView!
    @IBOutlet weak var activitiesTextView: UITextView!
    
    //labels
    @IBOutlet weak var typeLabel: UILabel!
    
    //images
    @IBOutlet weak var petImage: UIImageView!
    
    //BarButtons
    @IBOutlet weak var binBarBtn: UIBarButtonItem!
    
    //views
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var specificView: UIView!
    
    @IBOutlet weak var activitiesView: UIView!
    
    @IBOutlet weak var labelView: UIView!
    
    
    //MARK: Variables
    
    //room, user, selected pet
    var selectedPet: PetProfile!
    var currentUser: User!
    var selectedRoom: Room!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "\(selectedPet.petName) Info:"
        
        if currentUser.fullNameLF != selectedRoom.creator {
            
            binBarBtn.isEnabled = false
            binBarBtn.image = nil
            
        }
        
        SetDetails()
        SetCorners()
    }
    
    //MARK: Actions
    @IBAction func binBBtnTapped(_ sender: Any) {
    
        let deleteALert = UIAlertController(title: "WARNING", message: "This is not a pet delete, this is a Pet Profile removal. Are you sure you want to remove the Pet Profile for \(selectedPet.petName)?", preferredStyle: .alert)
        
        deleteALert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteALert.addAction(UIAlertAction(title: "Delete Profile", style: .destructive, handler: { (delete) in
            
            print("Should delete profile")
            
            self.DeleteProfile()
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(deleteALert, animated: true, completion: nil)
    
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    
    func SetDetails() {
        
        typeLabel.text = "Pet Type: \(selectedPet.petType)"
        
        descriptionTextView.text = selectedPet.description
        specificNeedsTextView.text = selectedPet.specificNeeds
        
        var activityString = ""
        
        for activity in selectedPet.activities {
            
            let activityIndex = selectedPet.activities.firstIndex(of: activity)!
            
            if activityIndex == 0 {
                
                activityString.append("\(activity): \nLast Done: \(selectedPet.tStamps[activityIndex])\n")
            }
            else {
                
                activityString.append("\n\(activity): \nLast Done: \(selectedPet.tStamps[activityIndex])\n")
            }
        }
        
        activitiesTextView.text = activityString
        
        switch selectedPet.petType {
        case "Dog":
            petImage.image = UIImage.init(named: "dogIcon")
        case "Cat":
            petImage.image = UIImage.init(named: "catIcon")
        case "Fish":
            petImage.image = UIImage.init(named: "fishIcon")
        default:
            print("Error loading image - Single Pet Info")
        }
        
    }
    
    func DeleteProfile() {
        
        //set database
        let database = Firestore.firestore()
        
        //get doc refference
        let docRef = database.collection("PetProfiles").document(selectedPet.petProfileID)
        
        //delete doc
        docRef.delete()
        
    }
    
    func SetCorners() {
        
        for view in [descriptionView, specificView, activitiesView] {
            view?.layer.cornerRadius = 20
        }
        
        for tView in [descriptionTextView, specificNeedsTextView, activitiesTextView] {
            tView?.layer.cornerRadius = 20
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
