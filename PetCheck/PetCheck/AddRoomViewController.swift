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
    
    
    //MARK: Variables

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
