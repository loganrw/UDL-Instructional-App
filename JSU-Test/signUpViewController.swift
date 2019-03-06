//
//  signUpViewController.swift
//  JSU-Test
//
//  Created by acns on 12/14/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class signUpViewController: UIViewController {

    @IBOutlet weak var emailField: logInTextField!
    @IBOutlet weak var passwordField: logInTextField!
    //Second feild to verify password
    @IBOutlet weak var rePassword: logInTextField!
    //Use this bool to decide if the user is istructor or a student
    @IBOutlet weak var isInstructor: UISwitch!

    
    @IBAction func backPressed(_ sender: UIButton) {
        presentStoryboard(boardName: "logInView")
        
    }
    
 
    @IBAction func createAccount(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text, rePassword.text == passwordField.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let fireBaseError = error{
                    let alert = UIAlertController(title: "Error", message: fireBaseError.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let uid = user?.uid
                let values = ["email": self.emailField.text!, "instructor": self.isInstructor.isOn, "newUser": true] as [String : Any]
                self.registerUserIntoDatabase(uid!, values: values as [String : AnyObject])
                let alert = UIAlertController(title: "Account Created", message: "You are now able to log in.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in switch action.style{
                default: self.presentStoryboard(boardName: "logInView")
                    }}))
                
                self.present(alert, animated: true, completion: nil)
            })
        }else if(rePassword.text != passwordField.text){
            let alert = UIAlertController(title: "Password Mismatch", message: "The passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    private func registerUserIntoDatabase(_ uid: String, values: [String: AnyObject]) {
    
        let ref = Database.database().reference()
        let usersReference = ref.child("Users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            //print("Successfully Added a New User to the Database")
        })
    }
}
