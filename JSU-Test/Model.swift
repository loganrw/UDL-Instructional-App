//
//  Model.swift
//  JSU-Test
//
//  Created by Logan Watkins on 8/31/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import UIKit
import Foundation

class customQuestionField: UIViewController {
    
    
    //Globals
    var questionPrompt = UIAlertController()
    var answerPrompt = UIAlertController()
    var customAnswer = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
    var customLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
    var customTextField = UITextView(frame: CGRect(x: 100, y: 475, width: 200, height: 50))
    var gesture = UIPanGestureRecognizer(target: self, action: Selector(("userDragged:")))
    let imagePicker = UIImagePickerController()
    
    //Creates a label that can serve as a question or statement. Called by the View.
    func createPrompt(type: String){
        
        //print("Question field created")
        
        //Set up the labels and make them draggable
        //Question
        customLabel.center = CGPoint(x: 175, y: 450)
        customLabel.textAlignment = .center
        customLabel.textColor = UIColor .black
        customLabel.adjustsFontSizeToFitWidth = true
        customLabel.isUserInteractionEnabled = true
        //Answer
        customAnswer.center = CGPoint(x: 175, y: 500)
        customAnswer.textAlignment = .center
        customAnswer.textColor = UIColor .black
        customAnswer.adjustsFontSizeToFitWidth = true
        customAnswer.isUserInteractionEnabled = true
        
        if(type == "Question"){
            //Create the prompt for when the user selects the "Add Question" button
            questionPrompt = UIAlertController(title: "Enter a question:", message: nil, preferredStyle: .alert)
            
            /*Add the actions that happen when the user presses the confirm button.
             The label will be updated; removed if cancel is pressed or set to the
             "textField" variable's value on confirm.
             */
            questionPrompt.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                let textField = self.questionPrompt.textFields![0] as UITextField
                //print("Text field: \(textField.text ?? "No Value")")
                self.customLabel.text = textField.text!
            }))
            
            questionPrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel){(_) in
                self.customLabel.removeFromSuperview()
            })
            
            
            //Add the text field that the user fills out
            questionPrompt.addTextField{ (textField) in
                textField.placeholder = "Enter your question.."
            }
        }
        
        if(type == "Answer"){
            //Answer Selected
            answerPrompt = UIAlertController(title: "Enter an answer:", message: nil, preferredStyle: .alert)
            
            answerPrompt.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
                let textField = self.answerPrompt.textFields![0] as UITextField
                //print("Text field: \(textField.text ?? "No Value")")
                self.customAnswer.text = textField.text!
            }))
            
            answerPrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel){(_) in
                self.customAnswer.removeFromSuperview()
            })
            
            answerPrompt.addTextField{ (textField) in
                textField.placeholder = "Enter your answer.."
            }
        }
        
    }
    
    //Takes a ViewController and adds the prompt and label
    func showQuestionPrompt(sender:UIViewController){
        
        sender.present(questionPrompt, animated: true, completion: nil)
        sender.view.addSubview(customLabel)
    }
    
    func addPicture(sender: UIViewController){
        imagePicker.delegate = sender as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        sender.present(imagePicker, animated: true, completion: nil)
    }

    
    
    //Adds a text field for multi-line input
    func addTextField(sender: UIViewController){
        customTextField.isEditable = true
        customTextField.addGestureRecognizer(gesture)
        customTextField.backgroundColor = UIColor .lightGray
        sender.view.addSubview(customTextField)
    }
    
    func showAnswerPrompt(sender: UIViewController){
        sender.present(answerPrompt, animated: true, completion: nil)
        customAnswer.isUserInteractionEnabled = true;
        sender.view.addSubview(customAnswer)
    }
    
    func userDragged(gesture: UIPanGestureRecognizer){
        var loc = gesture.location(in: self.view)
        self.customTextField.center = loc
        
    }
    
}


