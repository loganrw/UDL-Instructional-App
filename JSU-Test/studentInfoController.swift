//
//  studentInfoController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 10/12/18.
//  Copyright © 2018 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class studentInfoController: UIViewController{
    

    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var gradeLevel: UILabel!
    @IBOutlet weak var studentNumber: UILabel!
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    
    var menuVisable = false;
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        if(!menuVisable){
            leadingC.constant = 250
            trailingC.constant = -250
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.ref.child("Users").child(user!.uid).child("values").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userInfo = snapshot.value as! [String: Any]
            self.studentName.text = userInfo["studentName"] as? String
            self.gradeLevel.text = userInfo["gradeLevel"] as? String
            self.schoolName.text = userInfo["schoolName"] as? String
            
            
        })
        self.ref.child("Users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userInfo = snapshot.value as! [String: Any]

        })
        
    }

    @IBAction func backButton(_ sender: UIButton) {
        
        presentStoryboard(boardName: "studentLogIn")
    }
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
}
