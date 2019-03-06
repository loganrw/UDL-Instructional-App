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
    var correctAnswerAlert = UIAlertController()
    var publishAlert = UIAlertController()
    var imageView = UIImageView()
    var imagePicker = UIImagePickerController()
    var quizBank: [[String]] = []
    var qLocations: [CGRect] = []
    var aLocations: [CGRect] = []
    var questionContainer: [UILabel] = []
    var answerContainer: [UILabel] = []
    var questionCount = 0
    var answerCount = 0
    var questionAdded = false
    var answerAdded = false
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(userLongPress(sender:)))
    let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(sender:)))
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(userPinched(sender:)))
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
    
    @IBAction func publishPressed(_ sender: UIButton) {
        let labels = self.view.subviews.compactMap { $0 as? UILabel }
        
        for label in labels {
            if(label.text?.contains("?") ?? false){
               questionContainer.append(label)
            }else{
               answerContainer.append(label)
            }
        }
        
        for qs in questionContainer{
            qLocations.append(qs.frame)
        }
        for ans in answerContainer{
            aLocations.append(ans.frame)
        }
        
        publishAlert = UIAlertController(title: "Publish", message: "Uploading the quiz will make it available to publish to your classroom. Would you like to continue?", preferredStyle: .alert)
        
        publishAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            print("Answers LOC: ",self.aLocations)
            print("Questions LOC: ",self.qLocations)
            print("Quiz Bank",self.quizBank)
            print("Answers", self.answerContainer)
            print("Questions", self.questionContainer)
        }))
        
        publishAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in}))
        
        present(publishAlert, animated: true, completion: nil)
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
        questionLabel.addGestureRecognizer(self.userPinchGesture())
        view.addSubview(questionLabel)
        //Create the prompt for when the user selects the "Add Question" button
        alert = UIAlertController(title: "Enter question "+(String)(questionCount+1)+":", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            let textField = self.alert.textFields![0] as UITextField
            questionLabel.text = textField.text
            self.quizBank[self.questionCount][0] = textField.text ?? "Nil"
            self.questionAdded = true
            self.questionsEqualAnswers()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){(_) in
            questionLabel.removeFromSuperview()
        })
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Enter your question.."
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
        answerLabel.addGestureRecognizer(self.userPinchGesture())
        view.addSubview(answerLabel)
        //Create the prompt for when the user selects the "Add Answer" button
        alert = UIAlertController(title: "Enter answer "+(String)(answerCount+1)+":", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            let textField = self.alert.textFields![0] as UITextField
            answerLabel.text = textField.text
            self.correctAnswerAlert = UIAlertController(title: "Is this the correct answer to question "+(String)(self.questionCount+1)+"?", message: nil, preferredStyle: .alert)
            self.correctAnswerAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                self.quizBank[self.questionCount][1] = answerLabel.text ?? "Nil"
                self.answerAdded = true
                self.questionsEqualAnswers()
            }))
            self.correctAnswerAlert.addAction(UIAlertAction(title: "No", style: .cancel){(_) in
            })
            
            self.present(self.correctAnswerAlert, animated: true, completion: nil)
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
        randTextField.addGestureRecognizer(self.userPinchGesture())
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
            imageView.addGestureRecognizer(self.userPinchGesture())
            
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
        initArray()
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
    
    func userPinchGesture() -> UIPinchGestureRecognizer{
        let upg = UIPinchGestureRecognizer(target: self, action: #selector(userPinched(sender:)))
        return upg
    }
    
    @objc func userLongPress(sender: UILongPressGestureRecognizer){
        if(sender.state == .began){
            alert = UIAlertController(title: "Remove Item?", message: nil, preferredStyle: .alert)
            let selectedView = sender.view
            let val = sender.view?.subviews.compactMap { $0 as? UILabel }
            print(val)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in

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
    
    @objc func userPinched(sender: UIPinchGestureRecognizer){
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
    
    //Custom function to present certain story boards.
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    func initArray(){
        for index in 0..<1000{
            quizBank.append([(String)(index)])
            for sindex in 0..<1{
                quizBank[index].append((String)(sindex))
            }
        }
    }
    
    func questionsEqualAnswers(){
        
        if(questionAdded && answerAdded){
            questionCount += 1
            answerCount += 1
            questionAdded = false
            answerAdded = false
        }
    }
    

}
