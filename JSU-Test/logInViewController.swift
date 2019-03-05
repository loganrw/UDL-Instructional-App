//
//  logInViewController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 11/30/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class logInViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var ref: DatabaseReference!
    var isInstructor = false
    var isNewUser = false
    
    
    @IBAction func newAccountPressed(_ sender: UIButton) {
        self.presentStoryboard(boardName: "signUp")
    }
  
    

    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let fireBaseError = error{
                    print(fireBaseError.localizedDescription)
                    return
                }else{
                    self.ref = Database.database().reference()
                    self.ref?.child("Users").child(user!.uid).child("instructor").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let item = snapshot.value as? Bool{
                            self.isInstructor = item
                        }
                        
                        if(self.isInstructor){
                                self.presentStoryboard(boardName: "Main")
                            }else{
                                self.presentStoryboard(boardName: "studentLogIn")
                            }
                    })
                    
                }
            })
        }
    }
    

    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }

}
