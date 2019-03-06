//
//  rosterController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 2/20/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class rosterController: UIViewController{
    

    @IBOutlet weak var roster: UITableView!
    var rosterArray = [""]
    let alertController = UIAlertController(title: "Add Student", message: nil, preferredStyle: .alert)
    
    
    
    @IBAction func addStudents(_ sender: UIButton) {
        // Create the actions
        alertController.addTextField{ (textField) in
            textField.placeholder = "Student Name"
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK Pressed")
            let textField = self.alertController.textFields![0] as UITextField
            let databaseRef = Database.database().reference()
            databaseRef.child("Users").queryOrdered(byChild: "studentName").queryEqual(toValue: textField.text).observeSingleEvent(of: .value, with: { (snapShot) in
                
                    self.rosterArray.append(textField.text!)
                    self.roster.beginUpdates()
                    self.roster.insertRows(at: [IndexPath(row: self.rosterArray.count+1, section: 0)], with: .automatic)
                    self.roster.endUpdates()
                    
                }
                
            )

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        presentStoryboard(boardName: "MainInstructor")
    }
    
    
    
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
}

