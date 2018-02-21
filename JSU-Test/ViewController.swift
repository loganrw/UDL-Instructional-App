//
//  ViewController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 8/31/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController{
    
    //Pop out menu vars. Control the distance of the pop out.
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    var menuVisable = false
    
    //Firebase Reference
    var rootRef: DatabaseReference!
    
    
    var customQuizItem = quizItem()
    
    //If the top left menu button is pressed we slide out the pop out menu.
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
    
    //Buttons On the Instructor Menu
    @IBAction func createQuestion(_ sender: UIButton) {
        customQuizItem.createQuizItem(item: "Question")
    }
    
    @IBAction func createAnswer(_ sender: UIButton) {
        customQuizItem.createQuizItem(item: "Answer")
    }
    
    @IBAction func createTextField(_ sender: UIButton) {
        customQuizItem.createQuizItem(item: "textField")
    }
    
    @IBAction func createImage(_ sender: UIButton) {
        
    }
    
    //Directs the user back to the log in screen.
    @IBAction func logOut(_ sender: UIButton) {
        presentStoryboard(boardName: "logInView")
    }
    
    override func viewDidLoad() {
        
    }
    
    //Custom function to present certain story boards.
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }

}

