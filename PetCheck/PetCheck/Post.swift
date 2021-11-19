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
    var petType: String
    var tStamp: String
    var user: String
    var postID: String
    
    var creator: String
    var roomName: String
    
    //Computed Properties
    var postString: String {
        return "\(user) \(activity) \(petName)"
    }
    
    //Inits
    init(activity: String, petName: String, petType: String, tStamp: String, user: String, creator: String, roomName: String, postID: String) {
        
        self.activity = activity
        self.petName = petName
        self.petType = petType
        self.tStamp = tStamp
        self.user = user
        self.creator = creator
        self.roomName = roomName
        self.postID = postID
        
    }
    
    
}
