//
//  RegisterViewController.swift
//  PetCheck
//
//  Created by Brandyn Roatch on 11/5/21.
//

import UIKit

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
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Register New Account"
        
        for tf in [firstNameTF, lastNameTF, emailTF, passwordTF, confirmPasswordTF] {
            tf?.delegate = self
        }
        
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
                
                navigationController?.popToRootViewController(animated: true)
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
