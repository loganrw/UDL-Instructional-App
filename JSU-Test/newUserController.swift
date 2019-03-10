//
//  newUserController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 10/12/18.
//  Copyright © 2018 Logan Watkins. All rights reserved.
//

import Foundation
import Firebase

class newUserController: UIViewController{
    
    
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var studentName: logInTextField!
    @IBOutlet weak var schoolName: logInTextField!
    @IBOutlet weak var gradeLevel: logInTextField!
    let user = Auth.auth().currentUser
    
    
    @IBAction func submitNewStudent(_ sender: Any) {
        let ref = Database.database().reference().child("Users").child((user!.uid))
        ref.child("newUser").setValue(false)
        ref.child("hasInstructor").setValue(false)
        ref.child("schoolName").setValue(schoolName.text)
        ref.child("studentName").setValue(studentName.text)
        ref.child("gradeLevel").setValue(gradeLevel.text)
        let alert = UIAlertController(title: "Thank You!", message: "You are now able to use your account.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in switch action.style{
        default: self.presentStoryboard(boardName: "studentLogIn")
            }}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
}
