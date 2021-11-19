//
//  PetProfile.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import Foundation

class PetProfile {
    
    //Stored Properties
    var petName: String
    var petType: String
    var description: String
    var specificNeeds: String
    var activities: [String]
    var tStamps: [String]
    var petProfileID: String
    
    //Computed Properties
    
    //inits
    init(petName: String, petType: String, description: String, specificNeeds: String, activities: [String], tStamps: [String] = [String](), petProfileID: String){
        
        self.petName = petName
        self.petType = petType
        self.description = description
        self.specificNeeds = specificNeeds
        self.activities = activities
        self.tStamps = tStamps
        self.petProfileID = petProfileID
        
    }
    
}
