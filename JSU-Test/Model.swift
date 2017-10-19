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
    var customLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
    
    //Creates a label that can serve as a question or statement. Called by the View.
    func createQuestion(){
        
        //print("Question field created")
        
        //Set up the label and make it draggable
        customLabel.center = CGPoint(x: 175, y: 450)
        customLabel.textAlignment = .center
        customLabel.textColor = UIColor .black
        customLabel.adjustsFontSizeToFitWidth = true;
        customLabel.isUserInteractionEnabled = true;
        
        
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
    
    //Takes a ViewController and adds the prompt and label
    func showQuestionPrompt(sender:UIViewController){
        
        sender.present(questionPrompt, animated: true, completion: nil)
        sender.view.addSubview(customLabel)
    }
    
}


