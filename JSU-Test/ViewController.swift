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
    var imageView = UIImageView(frame: CGRect(x: 100, y: 4525, width: 400, height: 400))
    
    @IBAction func textFieldButton(_ sender: UIButton) {
        let customTextField = customQuestionField()
        customTextField.addTextField(sender: self)
        //print("Custom Text Created")
    }
    
    @IBAction func questionFieldButton(_ sender: UIButton) {
        let customQuestion = customQuestionField()
        customQuestion.createPrompt(type: "Question")
        customQuestion.showQuestionPrompt(sender: self)
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
        print("Image created")
        let customImage = customQuestionField()
        customImage.addPicture(sender: self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        
        self.dismiss(animated: true, completion: { () -> Void in
        })
        self.imageView.image = image;
    }
    
    @IBAction func answerButton(_ sender: UIButton) {
        print("Answer button created")
        let customAnswer = customQuestionField()
        customAnswer.createPrompt(type: "Answer")
        customAnswer.showAnswerPrompt(sender: self)
        customAnswer.makeDeletable(item: "Answer")
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

