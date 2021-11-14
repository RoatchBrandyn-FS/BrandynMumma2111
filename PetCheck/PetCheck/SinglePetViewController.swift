//
//  SinglePetViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/14/21.
//

import UIKit

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
    
    //MARK: Variables
    
    //room
    var selectedPet: PetProfile!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "\(selectedPet.petName) Info:"
        
        SetDetails()
    }
    
    //MARK: Actions
    
    //MARK: Objects
    
    //MARK: Methods
    
    func SetDetails() {
        
        typeLabel.text = "Pet Type: \(selectedPet.petType)"
        
        descriptionTextView.text = selectedPet.description
        specificNeedsTextView.text = selectedPet.specificNeeds
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
