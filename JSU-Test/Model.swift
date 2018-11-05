//
//  Model.swift
//  JSU-Test
//
//  Created by acns on 2/14/18.
//  Copyright © 2018 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit

class quizItem: UIViewController{
    
    var alert = UIAlertController()
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(userLongPress(sender:)))
    let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(sender:)))
    
    
    
    func createQuizItem(item: String){
        switch item {
            
        case "Answer":
            //print("Answer Created")
            //Prepare the quiz item
            let answerLabel = UILabel(frame: CGRect(x: 200, y: 200, width: 300, height: 20))
            answerLabel.isUserInteractionEnabled = true
            answerLabel.textColor = UIColor .black
            answerLabel.addGestureRecognizer(self.longPressGesture())
            answerLabel.addGestureRecognizer(self.movePanGesture())
            topViewController()?.view.addSubview(answerLabel)
            //Create the prompt for when the user selects the "Add Answer" button
            alert = UIAlertController(title: "Enter an answer:", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                let textField = self.alert.textFields![0] as UITextField
                answerLabel.text = textField.text
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){(_) in
                answerLabel.removeFromSuperview()
            })
            alert.addTextField{ (textField) in
                textField.placeholder = "Enter your answer.."
            }
            
            topViewController()?.present(alert, animated: true, completion: nil)
            
            
        case "textField":
            let randTextField = UITextField(frame: CGRect(x: 200, y: 200, width: 300, height: 35))
            randTextField.isUserInteractionEnabled = true
            randTextField.backgroundColor = UIColor .lightGray
            randTextField.placeholder = "Enter your message..."
            randTextField.addGestureRecognizer(self.longPressGesture())
            randTextField.addGestureRecognizer(self.movePanGesture())
            topViewController()?.view.addSubview(randTextField)
            
            
            
        case "Question":
            //print("Question Created")
            //Prepare the quiz item
            let questionLabel = UILabel(frame: CGRect(x: 200, y: 200, width: 300, height: 20))
            questionLabel.isUserInteractionEnabled = true
            questionLabel.textColor = UIColor .black
            questionLabel.addGestureRecognizer(self.longPressGesture())
            questionLabel.addGestureRecognizer(self.movePanGesture())
            topViewController()?.view.addSubview(questionLabel)
            //Create the prompt for when the user selects the "Add Question" button
            alert = UIAlertController(title: "Enter an question:", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                let textField = self.alert.textFields![0] as UITextField
                questionLabel.text = textField.text
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){(_) in
                questionLabel.removeFromSuperview()
            })
            alert.addTextField{ (textField) in
                textField.placeholder = "Enter your answer.."
            }
            
            topViewController()?.present(alert, animated: true, completion: nil)
            
            
        case "Image":
            print("Image Created")
            
        default:
            print("Unrecognized Quiz Type")
        }
    }
    
    
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(userLongPress(sender:)))
        lpg.minimumPressDuration = 0.5
        return lpg
    }
    
    func movePanGesture() -> UIPanGestureRecognizer {
        let mpg = UIPanGestureRecognizer(target: self, action: #selector(userDragged(sender:)))
        return mpg
    }
    
    @objc func userLongPress(sender: UILongPressGestureRecognizer){
        if(sender.state == .began){
            alert = UIAlertController(title: "Remove Item?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                let selectedView = sender.view
                selectedView?.removeFromSuperview()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel){(_) in
                
            })
            
            topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func userDragged(sender: UIPanGestureRecognizer){
        let loc = sender.location(in: self.view)
        let selectedView = sender.view
        selectedView?.center = loc
        
    }
    
    
    func topViewController() -> UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while topViewController.presentedViewController != nil {
            topViewController = topViewController.presentedViewController!
        }
        return topViewController
    }
    
    
    
}
