//
//  TabbedViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import UIKit

class TabbedViewController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Variables
    
    //room
    var selectedRoom: Room!
    
    //bools
    var roomConfirmed = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SetRoomDetails()
    }
    //MARK: Actions
    
    //MARK: Objects
    
    //MARK: Methods
    
    func SetRoomDetails() {
        
        print("\(selectedRoom.name) in Tabbed Room")
        
        if selectedRoom != nil {
            navigationItem.title = "Room: \(selectedRoom.name)"
        }
        else {
            navigationItem.title = "Room: Not Loaded"
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
