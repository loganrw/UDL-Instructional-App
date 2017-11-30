//
//  logInViewController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 11/30/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class logInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func logInPressed(_ sender: UIButton) {
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
    
    @IBAction func signUpPressed(_ sender: UIButton) {
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
    
    func presentLogIn(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInVC:ViewController = storyboard.instantiateViewController(withIdentifier: "Main") as! ViewController
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
}
