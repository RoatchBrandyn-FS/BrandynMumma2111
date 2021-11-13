//
//  TabbedViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import UIKit

class PostsViewController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Variables
    
    //room
    var selectedRoom: Room!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tabbar = tabBarController as! TabBarController
        print(String("Current Room: \(tabbar.selectedRoom.name)"))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    //MARK: Actions
    
    //MARK: Objects
    
    //MARK: Methods
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
