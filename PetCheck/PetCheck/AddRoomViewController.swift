//
//  AddRoomViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/11/21.
//

import UIKit

class AddRoomViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    //views
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var tfView: UIView!
    @IBOutlet weak var btnView: UIView!
    
    //text fields
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    
    //labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idWarningLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    //buttons
    @IBOutlet weak var createBtn: UIButton!
    
    
    //MARK: Variables
    var currentUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Add New Room"
        
        for tf in [nameTF, idTF, passwordTF, confirmTF] {
            tf?.delegate = self
        }
        
        ViewSetup()
        
        
    }
    
    //MARK: Actions
    @IBAction func createBtnTapped(_ sender: Any) {
        
        if nameTF.text?.isEmpty == true || idTF.text?.isEmpty == true || passwordTF.text?.isEmpty == true || confirmTF.text?.isEmpty == true {
            
            TFEmpty()
            RemovePasswordInfo()
            
            let emptyAlert = UIAlertController(title: "Sorry...", message: "Not all required fields were filled. Please fill in all fields in red, and re-enter the password and confirmed password.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(emptyAlert, animated: true, completion: nil)
            
        }
        else {
            
            //Run a match check for either matching password/confirm is correct and that room name/roomID don't match before moving on
            for label in [nameLabel, idLabel, idWarningLabel, passwordLabel, confirmLabel] {
                
                label?.backgroundColor = UIColor.clear
                
            }
            
            CheckMatch()
            
            
        }
        
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    
    func ViewSetup(){
        
        for view in [viewContainer, labelView, tfView, btnView] {
            view?.layer.cornerRadius = 20
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func TFEmpty() {
        
        for label in [nameLabel, idLabel, passwordLabel, confirmLabel] {
            
            label?.backgroundColor = UIColor.clear
            
        }
        
        if nameTF.text?.isEmpty == true {
            nameLabel.backgroundColor = UIColor.red
            
        }
        
        if idTF.text?.isEmpty == true {
            idLabel.backgroundColor = UIColor.red
            
        }
        
        if passwordTF.text?.isEmpty == true {
            passwordLabel.backgroundColor = UIColor.red
            
        }
        
        if confirmTF.text?.isEmpty == true {
            confirmLabel.backgroundColor = UIColor.red
            
        }
        
    }
    
    func RemovePasswordInfo() {
        passwordTF.text?.removeAll()
        confirmTF.text?.removeAll()
    }
    
    func CheckMatch() {
        
        if nameTF.text == idTF.text {
            
            let matchAlert = UIAlertController(title: "Sorry...", message: "All required fields are filled, but the Room Name can't match the RoomID.", preferredStyle: .alert)
            
            matchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(matchAlert, animated: true, completion: nil)
            
            RemovePasswordInfo()
            
            nameLabel.backgroundColor = UIColor.red
            idWarningLabel.backgroundColor = UIColor.red
            
            
        }
        else if passwordTF.text != confirmTF.text {
            
            let matchAlert = UIAlertController(title: "Sorry...", message: "All required fields are filled, but the password needs to match the confirmed password.", preferredStyle: .alert)
            
            matchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(matchAlert, animated: true, completion: nil)
            
            RemovePasswordInfo()
            
            passwordLabel.backgroundColor = UIColor.red
            confirmLabel.backgroundColor = UIColor.red
            
            
            
        }
        else {
            
            SaveRoomData()
            
            let saveAlert = UIAlertController(title: "New Room!", message: "\(currentUser.fullNameFL) created new room \(nameTF.text!)!", preferredStyle: .alert)
            
            saveAlert.addAction(UIAlertAction(title: "Back to Rooms Lobby", style: .default, handler: {_ in
                
                self.navigationController?.popViewController(animated: true)
                
            }))
            
            present(saveAlert, animated: true, completion: nil)
            
        }
        
    }
    
    func SaveRoomData() {
        
        print("\(currentUser.fullNameLF) in Add Room")
        
        
    }
    

    /*
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
