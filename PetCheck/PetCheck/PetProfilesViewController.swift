//
//  PetProfilesViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/12/21.
//

import UIKit

class PetProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    
    //views
    @IBOutlet weak var petProfilesTV: UITableView!
    
    //MARK: Variables
    
    //arrays
    var allPets = [PetProfile]()
    var allCats = [PetProfile]()
    var allDogs = [PetProfile]()
    var allFishes = [PetProfile]()
    var sortedPets = [[PetProfile]]()
    
    //room
    var selectedRoom: Room!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tabbar = tabBarController as! TabBarController
        selectedRoom = tabbar.selectedRoom
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    //MARK: Actions
    
    //MARK: Objects
    
    //MARK: Methods
    
    
    //MARK: Tableview callbacks
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sortedPets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPets[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse id
        let cell = petProfilesTV.dequeueReusableCell(withIdentifier: "pet_cell_01", for: indexPath)
        
        //cell configure
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
