//
//  SettingsViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/18/21.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var settingsTV: UITableView!
    
    //MARK: Variables
    
    //arrays
    let creatorSettings = ["Leave Room", "Logout", "Delete Room"]
    let userSettings = ["Leave Room", "Logout"]
    
    //user and room
    var selectedRoom: Room!
    var currentuser: User!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tabbar = tabBarController as! TabBarController
        
        selectedRoom = tabbar.selectedRoom
        currentuser = tabbar.currentUser
        
        settingsTV.delegate = self
        settingsTV.dataSource = self
        
    }
    
    //MARK: Actions
    
    //MARK: Objects
    
    //MARK: Methods
    
    func LeaveRoom() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func Logout() {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK: Tableview callbacks
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentuser.fullNameLF == selectedRoom.creator {
            return creatorSettings.count
        }
        else {
            return userSettings.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set reuse id
        let cell = settingsTV.dequeueReusableCell(withIdentifier: "setting_cell_01", for: indexPath)
        
        //configure cell
        var setting = ""
        
        if currentuser.fullNameLF == selectedRoom.creator {
            setting = creatorSettings[indexPath.row]
            
        }
        else {
            setting = userSettings[indexPath.row]
        }
        
        cell.textLabel?.text = setting
        
        switch setting {
        case "Leave Room":
            cell.imageView?.image = UIImage.init(systemName: "arrowshape.turn.up.left")
        case "Logout":
            cell.imageView?.image = UIImage.init(systemName: "arrowshape.turn.up.left.2")
        case "Delete Room":
            cell.imageView?.image = UIImage.init(systemName: "xmark.square")
            cell.textLabel?.textColor = UIColor.red
            cell.tintColor = UIColor.red
        default:
            print("Error setting table view - Settings tab")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Settings"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var settingChoice = ""
        
        if currentuser.fullNameLF == selectedRoom.creator {
            settingChoice = creatorSettings[indexPath.row]
            
        }
        else {
            settingChoice = userSettings[indexPath.row]
            
        }
        
        switch settingChoice {
        case "Leave Room":
            print("Should Leave Room")
            LeaveRoom()
        case "Logout":
            print("Should logout to first view")
            Logout()
        case "Delete Room":
            print("Should delete room, and return to All Rooms View")
        default:
            print("Error choosing settings option")
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
