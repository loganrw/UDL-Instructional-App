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
    
    override func viewDidAppear(_ animated: Bool) {
        self.ref.child("Users").child(user!.uid).child("values").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userInfo = snapshot.value as! [String: Any]
            self.studentName.text = userInfo["studentName"] as? String
            self.gradeLevel.text = userInfo["gradeLevel"] as? String
            self.studentNumber.text = userInfo["userID"] as? String
            self.schoolName.text = userInfo["schoolName"] as? String
            
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
