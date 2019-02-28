//
//  ViewController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 8/31/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Pop out menu vars. Control the distance of the pop out.
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    var menuVisable = false
    var alert = UIAlertController()
    var imageView = UIImageView()
    var imagePicker = UIImagePickerController()
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(userLongPress(sender:)))
    let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(sender:)))
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    //Firebase Reference
    var rootRef: DatabaseReference!
    
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
        //print("Question Created")
        //Prepare the quiz item
        let questionLabel = UILabel(frame: CGRect(x: 200, y: 200, width: 300, height: 20))
        questionLabel.isUserInteractionEnabled = true
        questionLabel.textColor = UIColor .black
        questionLabel.addGestureRecognizer(self.longPressGesture())
        questionLabel.addGestureRecognizer(self.movePanGesture())
        view.addSubview(questionLabel)
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
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createAnswer(_ sender: UIButton) {
        //print("Answer Created")
        //Prepare the quiz item
        let answerLabel = UILabel(frame: CGRect(x: 200, y: 200, width: 300, height: 20))
        answerLabel.isUserInteractionEnabled = true
        answerLabel.textColor = UIColor .black
        answerLabel.addGestureRecognizer(self.longPressGesture())
        answerLabel.addGestureRecognizer(self.movePanGesture())
        view.addSubview(answerLabel)
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
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func createTextField(_ sender: UIButton) {
        
        let randTextField = UITextField(frame: CGRect(x: 200, y: 200, width: 300, height: 35))
        randTextField.isUserInteractionEnabled = true
        randTextField.backgroundColor = UIColor .lightGray
        randTextField.placeholder = "Enter your message..."
        randTextField.addGestureRecognizer(self.longPressGesture())
        randTextField.addGestureRecognizer(self.movePanGesture())
        view.addSubview(randTextField)
    }
    
    @IBAction func createImage(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(self.longPressGesture())
            imageView.addGestureRecognizer(self.movePanGesture())
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = pickedImage
            imageView.frame = CGRect(x: w / 2, y: h / 2, width: 200, height: 200)
            view.addSubview(imageView)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //Directs the user back to the log in screen.
    @IBAction func logOut(_ sender: UIButton) {
        presentStoryboard(boardName: "logInView")
    }
    
    override func viewDidLoad() {
        self.rootRef = Database.database().reference()
        self.rootRef?.child("Users").child((Auth.auth().currentUser?.uid)!).child("newUser").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? Bool{
                if item == true{
                    self.presentStoryboard(boardName: "newInstructor")
                }
            }
        })
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
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func userDragged(sender: UIPanGestureRecognizer){
        let loc = sender.location(in: self.view)
        let selectedView = sender.view
        selectedView?.center = loc
        
    }
    
    
    //Custom function to present certain story boards.
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }

}

