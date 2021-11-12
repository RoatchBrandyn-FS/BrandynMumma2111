//
//  RegisterViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/5/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    //Text Fields
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    //Labels
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var createBtn: UIButton!
    
    //Views
    @IBOutlet weak var viewContainerView: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var tfView: UIView!
    @IBOutlet weak var btnView: UIView!
    
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Register New Account"
        
        for tf in [firstNameTF, lastNameTF, emailTF, passwordTF, confirmPasswordTF] {
            tf?.delegate = self
        }
        
        SetCorners()
        
    }
    
    //MARK: Actions
    @IBAction func createBtnTapped(_ sender: UIButton) {
        
        if firstNameTF.text?.isEmpty == true || lastNameTF.text?.isEmpty == true || emailTF.text?.isEmpty == true || passwordTF.text?.isEmpty == true || confirmPasswordTF.text?.isEmpty == true {
            
            print("TF is empty")
            
            TFEmpty()
            passwordTF.text?.removeAll()
            confirmPasswordTF.text?.removeAll()
            
            let emptyAlert = UIAlertController(title: "Sorry...", message: "Not all required fields were filled. Please fill in all fields in red, and re-enter the password and confirmed password.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(emptyAlert, animated: true, completion: nil)
            
        }
        
        else {
            
            if passwordTF.text != confirmPasswordTF.text {
                
                let matchAlert = UIAlertController(title: "Sorry...", message: "All required fields are filled, but the password needs to match the confirmed password.", preferredStyle: .alert)
                
                matchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                present(matchAlert, animated: true, completion: nil)
                
                passwordTF.text?.removeAll()
                confirmPasswordTF.text?.removeAll()
                
                passwordLabel.textColor = UIColor.red
                confirmPasswordLabel.textColor = UIColor.red
                
                
            }
            
            else{
                
                print("All TF's filled and both Passwords match.")
                
                SaveUserData(firstName: firstNameTF.text!, lastName: lastNameTF.text!, email: emailTF.text!, password: passwordTF.text!)
                
                let saveAlert = UIAlertController(title: "New User Registered!", message: "User registration successful for \(firstNameTF.text!) and ready to login!", preferredStyle: .alert)
                
                saveAlert.addAction(UIAlertAction(title: "Back to Login", style: .default, handler: {_ in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }))
                
                present(saveAlert, animated: true, completion: nil)
                
            }
            
            
        }
        
    }
    
    //MARK: Objects
    
    //MARK: Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func TFEmpty(){
        
        //reset all colors back to normal if something changes or if the user forgets to re input the password twice
        for tf in [firstNameLabel, lastNameLabel, emailLabel, passwordLabel, confirmPasswordLabel] {
            tf?.textColor = UIColor.black
        }
        
        if firstNameTF.text?.isEmpty == true {
            firstNameLabel.textColor = UIColor.red
        }
        
        if lastNameTF.text?.isEmpty == true {
            lastNameLabel.textColor = UIColor.red
        }
        
        if emailTF.text?.isEmpty == true {
            emailLabel.textColor = UIColor.red
        }
        
        if passwordTF.text?.isEmpty == true {
            passwordLabel.textColor = UIColor.red
        }
        
        if confirmPasswordTF.text?.isEmpty == true {
            confirmPasswordLabel.textColor = UIColor.red
        }
        
    }
    
    func SaveUserData(firstName: String, lastName: String, email: String, password: String){
        
        //database reference, like when reading from firestore
        let database = Firestore.firestore()
        
        //add document to the user collection
        database.collection("Users").addDocument(data: ["firstName": firstName, "lastName": lastName, "email": email, "password": password]) { (error) in
            //Check for errors
            
            if error == nil {
                //No Errors
                
            }
            else{
                //Deal with error(s)
            }
        }
        
    }
    
    func SetCorners() {
        
        for view in [viewContainerView, labelView, tfView, btnView]{
            
            view?.layer.cornerRadius = 20
            
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
