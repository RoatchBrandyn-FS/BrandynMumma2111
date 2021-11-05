//
//  ViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/4/21.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    
    //Text Fields
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    //Buttons
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: Variables
    var confirmedUser: User? = nil
    var allUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        ReadUserDoc()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        
        var credentialsConfrimed = false
        
        for user in allUsers {
            
            if credentialsConfrimed == false {
                
                print("emailTF: \(emailTF.text!) / user email: \(user.email)")
                print("passwordTF: \(passwordTF.text!) / user password: \(user.password)")
                
                if user.email == emailTF.text && user.password == passwordTF.text {
                    
                    credentialsConfrimed = true
                    confirmedUser = user
                    
                    
                }
                
            }
        }
        
        if credentialsConfrimed == true, let cu = confirmedUser {
            
            let userCheckAlert = UIAlertController(title: "Action Complete", message: "Email and Password worked! Should login \(cu.fullNameLF).", preferredStyle: .alert)
            
            userCheckAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(userCheckAlert, animated: true, completion: nil)
            
        }
        else{
            
            let userCheckAlert = UIAlertController(title: "Login Error...", message: "Email and Password provied didn't match any users. Please try again.", preferredStyle: .alert)
            
            userCheckAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(userCheckAlert, animated: true, completion: nil)
            
        }
        
        emailTF.text?.removeAll()
        passwordTF.text?.removeAll()
        
    }
    
    func ReadUserDoc() {
        
        //Check all users here
        // Get database reference
        let database = Firestore.firestore()
        
        //Read documents
        database.collection("Users").getDocuments { (snapshot, error) in
            
            //check errors
            if error == nil {
                //get all users and create a user obj for each
                
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (doc) in
                        
                        guard let firstName = doc["firstName"] as? String, let lastName = doc["lastName"] as? String, let email = doc["email"] as? String, let password = doc["password"] as? String
                        else{ return }
                        
                        print("\(firstName) /\(lastName) /\(email) /\(password)")
                        
                        self.allUsers.append(User(firstName: firstName, lastName: lastName, email: email, password: password))
                        print("\(self.allUsers.count.description) - In snapshot foreach")
                        
                    })
                    
                    print("\(self.allUsers.count.description) - In dispatchqueue")
                    
                }
                
            }
            else{
                print("Error occured loading from firebase")
            }
            
        }
        
    }


}

