//
//  Post.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import Foundation

class Post {
    
    //Stored Properties
    var activity: String
    var petName: String
    var tStamp: Date
    var user: String
    
    var creator: String
    var roomName: String
    
    //Computed Properties
    var postString: String {
        return "\(user) \(activity) \(petName)"
    }
    
    //Inits
    init(activity: String, petName: String, tStamp: Date, user: String, creator: String, roomName: String) {
        
        self.activity = activity
        self.petName = petName
        self.tStamp = tStamp
        self.user = user
        self.creator = creator
        self.roomName = roomName
        
    }
    
    
}
