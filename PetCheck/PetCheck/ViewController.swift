//
//  ViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/4/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    
    //Text Fields
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    //Buttons
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: Variables
    var confirmedUser: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Firestore Test")
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
    }
    
    //MARK: Actions
    @IBAction func btnTapped(_ sender: UIButton){
        
        switch sender.currentTitle {
        case "Login":
            print("Login Tapped")
            CheckText()
        
        case "Register":
            print("Register Tapped")
            
        default:
            print("Error - Not a valid button for this action")
        }
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func CheckText() {
        
        if emailTF.text?.isEmpty == true && passwordTF.text?.isEmpty == true {
            
            //Both Email and Pasword are empty
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to login: Email and Password show empty.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
        }
        
        else if emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == true {
            
            //emailTF is filled, but passwordTF is empty
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to login: Password show empty.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
        }
        
        else if emailTF.text?.isEmpty == true && passwordTF.text?.isEmpty == false {
            
            //passwordTF is filled, but emailTF is empty
            // -> in this case, make sure to empty the passwordTF
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to login: Email show empty.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            passwordTF.text?.removeAll()
            
        }
        else {
            
            //both should be filled
            CheckUsers()
            
        }
        
    }
    
    func CheckUsers() {
        
        //Alert will be removed when this func is working correctly
        let userCheckAlert = UIAlertController(title: "Action Complete", message: "Data should check all users and if complete, the user should be logged in", preferredStyle: .alert)
        
        userCheckAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(userCheckAlert, animated: true, completion: nil)
        
        var allUsers = [User]()
        
        // Get database reference
        
        //Read documents
        
        
        
        
        
    }


}

