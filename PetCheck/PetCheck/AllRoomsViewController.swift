//
//  AllRoomsViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/5/21.
//

import UIKit

class AllRoomsViewController: UIViewController {
    
    //MARK: Outlets
    
    //views
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Variables
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Room Search"
        navigationItem.hidesBackButton = true
        tableView.layer.cornerRadius = 20
        
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
