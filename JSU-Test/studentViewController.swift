//
//  studentViewController.swift
//  JSU-Test
//
//  Created by acns on 12/15/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class studentViewController: UIViewController {
    
    
    @IBOutlet weak var studentView: UIView!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    var menuVisable = false
    var instructorAdded = false
    
    var rootRef: DatabaseReference!
    
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        self.presentStoryboard(boardName: "logInView")
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if(!menuVisable){
            leadingC.constant = 150
            trailingC.constant = -150
            menuVisable = true
            
        }else{
            leadingC.constant = -20
            trailingC.constant = -20
            menuVisable = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations:{
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func quizButtonPressed(_ sender: UIButton) {
        self.presentStoryboard(boardName: "quizView")
    }
    
    @IBAction func studentInfoPressed(_ sender: UIButton) {
        self.presentStoryboard(boardName: "studentInfo")
    }
    
    
    override func viewDidLoad() {
        self.rootRef = Database.database().reference()
        self.rootRef?.child("Users").child((Auth.auth().currentUser?.uid)!).child("newUser").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? Bool{
                if item == true{
                    self.presentStoryboard(boardName: "newStudent")
                }
            }
        })
        
        self.rootRef?.child("Users").child((Auth.auth().currentUser?.uid)!).child("hasInstructor").observeSingleEvent(of: .value, with: { (snapshot) in
            
                if let item = snapshot.value as? Bool{
                    if item == false{
                        let instructorAlert = UIAlertController(title: "Add Instrcutor", message: "Enter your instructors Course Code to be added to their classroom.", preferredStyle: .alert)
                        instructorAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                            let textField = instructorAlert.textFields![0] as UITextField
                            self.rootRef.child("Users").queryOrdered(byChild: "classCode").queryEqual(toValue: textField.text)
                                .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                                    
                                    if snapshot.exists() {
                                        self.rootRef.child("classCode").setValue(textField.text)
                                    }
                                    else {
                                        print("FALSE")
                                    }
                                })
                        }))
            
                        instructorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel){(_) in})
            
                        instructorAlert.addTextField{ (textField) in
                            textField.placeholder = "Enter your instructors code.."
                        }
                        self.present(instructorAlert, animated: true, completion: nil)
                    }}})
        }
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    


}
