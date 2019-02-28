//
//  MainInstructorController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 2/20/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class MainInstructorController:  UIViewController {
    

    @IBAction func getRoster(_ sender: UIButton) {
        presentStoryboard(boardName: "Roster")
    }
    
    @IBAction func getGradebook(_ sender: UIButton) {
        presentStoryboard(boardName: "Gradebook")
    }
    
    @IBAction func getQuizLab(_ sender: UIButton) {
        presentStoryboard(boardName: "Main")
    }
    
    @IBAction func getMessages(_ sender: UIButton) {
        //presentStoryboard(boardName: "Messages")
    }
    
    @IBAction func getFeedbackInfo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Feedback/Report", message: "Please send all feedback or reports to myjsulearn@gmail.com.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel){(_) in})
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            presentStoryboard(boardName: "logInView")
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            
        }
        
    }
    
    
    
    
    
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
}
