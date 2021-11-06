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
    
    //MARK: Objects
    
    //MARK: Methods
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if firstNameTF.text?.isEmpty == true || lastNameTF.text?.isEmpty == true || emailTF.text?.isEmpty == true || passwordTF.text?.isEmpty == true || confirmPasswordTF.text?.isEmpty == true {
            
            print("TF is empty")
            return false
            
        }
        
        else {
            print("All TF's filled")
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
