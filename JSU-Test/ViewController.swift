//
//  ViewController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 8/31/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var rootRef: DatabaseReference!

    @IBAction func textFieldButton(_ sender: UIButton) {
        print("Custom Text Created")
    }
    
    @IBAction func questionFieldButton(_ sender: UIButton) {
        let customQuestion = customQuestionField()
        customQuestion.createQuestion()
        customQuestion.showQuestionPrompt(sender: self)
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
        print("Image created")
    }
    
    @IBAction func answerButton(_ sender: UIButton) {
        print("Answer button created")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let questionsRef = rootRef.child("Questions")
        questionsRef.observe(.value) { (snap: DataSnapshot) in
            print(snap)
        }
    }
    

}

