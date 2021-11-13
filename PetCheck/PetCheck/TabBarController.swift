//
//  TabBarController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    //MARK: Variables
    
    //room
    var selectedRoom: Room!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SetRoomDetails()
        
        selectedIndex = 0
        
        
    }
    
    func SetRoomDetails() {
        
        //print("\(selectedRoom.name) in Tabbed Room")
        
        if selectedRoom != nil {
            navigationItem.title = "Room: \(selectedRoom.name)"
        }
        else {
            navigationItem.title = "Room: Not Loaded"
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Home" {
            print("Tab 1 Tapepd")
        }
        else if item.title == "My Pets"{
            print("Tab 2 Tapped")
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if selectedIndex == 0 {
            print("Index was 0")
        }
        else if selectedIndex == 1 {
            print("Index was 1")
        }
        
        
    }
    

}
