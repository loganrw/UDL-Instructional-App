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
    var menuVisable = false;
    
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
    }
    

    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    


}
