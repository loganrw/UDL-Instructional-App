//
//  newInstructorController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 3/8/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class newInstructorController: UIViewController {
    
    @IBOutlet weak var classCode: UITextField!
    @IBOutlet weak var gradeLevel: UITextField!
    @IBOutlet weak var schoolName: UITextField!
    @IBOutlet weak var instructorName: UITextField!
      let user = Auth.auth().currentUser
    
    @IBAction func submitInstructor(_ sender: UIButton) {
        let ref = Database.database().reference().child("Users").child((user!.uid))
        ref.child("newUser").setValue(false)
        ref.child("classCode").setValue(classCode.text)
        ref.child("instructorName").setValue(instructorName.text)
        ref.child("schoolName").setValue(schoolName.text)
        ref.child("gradeLevel").setValue(gradeLevel.text)
        let alert = UIAlertController(title: "Thank You!", message: "You are now able to use your account.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in switch action.style{
        default: self.presentStoryboard(boardName: "MainInstructor")
            }}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
        
        func presentStoryboard(boardName: String){
            let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
            let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
            self.present(loggedInVC, animated: true, completion: nil)
        }
}
