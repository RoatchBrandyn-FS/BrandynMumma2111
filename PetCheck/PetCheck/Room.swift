//
//  Room.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/6/21.
//

import Foundation

class Room {
    
    //Stored Properties
    var name: String
    var creator: String
    var roomID: String
    var password: String
    
    //Computed Properties
    
    //Inits
    init(name: String, creator: String, roomID: String, password: String) {
        self.name = name
        self.creator = creator
        self.roomID = roomID
        self.password = password
        
    }
    
    
}
