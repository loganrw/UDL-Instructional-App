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
    @IBOutlet weak var slideView: UIView!

    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    var imageView = UIImageView(frame: CGRect(x: 100, y: 4525, width: 400, height: 400))
    let customQuestion = customQuestionField()
    let customImage = customQuestionField()
    let customAnswer = customQuestionField()
    let customTextField = customQuestionField()
    var menuVisable = false
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
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
    
  
    
    
    
    @IBAction func textFieldButton(_ sender: UIButton) {
        
        customTextField.addTextField(sender: self)
        //print("Custom Text Created")
    }
    
    @IBAction func questionFieldButton(_ sender: UIButton) {
        customQuestion.createPrompt(type: "Question")
        customQuestion.showQuestionPrompt(sender: self)
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
        print("Image created")
        customImage.addPicture(sender: self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        
        self.dismiss(animated: true, completion: { () -> Void in
        })
        self.imageView.image = image;
    }
    @IBAction func logOut(_ sender: UIButton) {
        presentStoryboard(boardName: "logInView")
    }
    
    @IBAction func answerButton(_ sender: UIButton) {
        print("Answer button created")
        customAnswer.createPrompt(type: "Answer")
        customAnswer.showAnswerPrompt(sender: self)
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
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }

}

