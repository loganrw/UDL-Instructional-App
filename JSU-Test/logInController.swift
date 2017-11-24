//
//  logInController.swift
//  
//
//  Created by Logan Watkins on 11/7/17.
//
//

import UIKit
import FirebaseAuth

class logInController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let fireBaseError = error{
                    print(fireBaseError.localizedDescription)
                    return
                }
                print("Account Created")
            })
        }
    }
    

    @IBAction func logInPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let fireBaseError = error{
                    print(fireBaseError.localizedDescription)
                    return
                }
                self.presentLogIn()
            })
        }
    }
    
    func presentLogIn(){
        let storyboard:UIStoryboard = UIStoryboard(name: "logInController", bundle: nil)
        let loggedInVC:logInController = storyboard.instantiateViewController(withIdentifier: "logInController") as! logInController
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    
}
