//
//  User.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/4/21.
//

import Foundation

class User {
    
    //Stored Property
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    
    //Computed Properties
    var fullNameFL: String {
        return "\(firstName) \(lastName)"
    }
    
    var fullNameLF: String {
        return "\(lastName), \(firstName)"
    }
    
    //inits
    init(firstName: String, lastName: String, email: String, password: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    
    
    
}
