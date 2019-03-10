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
    
    var alert = UIAlertController()
    var correctAnswerAlert = UIAlertController()
    var quizNameAlert = UIAlertController()
    var publishAlert = UIAlertController()
    var imagePicker = UIImagePickerController()
    var quizBank: [[String]] = []
    var qLocations: [String] = []
    var aLocations: [String] = []
    var questionContainer: [UILabel] = []
    var answerContainer: [UILabel] = []
    var imageContainer = [UIImage]()
    var imageFrames = [String]()
    var questionCount = 0
    var answerCount = 0
    var questionAdded = false
    var answerAdded = false
    var quizName = ""
    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(userLongPress(sender:)))
    let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(sender:)))
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(userPinched(sender:)))
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    
    //Firebase Reference
    var rootRef: DatabaseReference!
    
    //Pop out menu vars. Control the distance of the pop out.
    var menuVisable = false;
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    //If the top left menu button is pressed we slide out the pop out menu.
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        if(!menuVisable){
            leadingC.constant = 250
            trailingC.constant = 0
            menuVisable = true
            
        }else{
            leadingC.constant = 0
            trailingC.constant = 0
            menuVisable = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations:{
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func backButton(_ sender: UIButton) {
        presentStoryboard(boardName: "MainInstructor")
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
            
            qLocations.append(NSStringFromCGRect(qs.frame))
        }
        for ans in answerContainer{
            aLocations.append(NSStringFromCGRect(ans.frame))
        }
        
        quizNameAlert = UIAlertController(title: "Quiz Name", message: "Enter the name for your quiz: ", preferredStyle: .alert)
        
        quizNameAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            
            let quizText = self.quizNameAlert.textFields![0] as UITextField
            self.quizName = quizText.text ?? "Nil"
            self.present(self.publishAlert, animated: true, completion: nil)
        }))
        
        quizNameAlert.addTextField{ (textField) in
            textField.placeholder = "Name your quiz..."
        }
        
        publishAlert = UIAlertController(title: "Publish", message: "Uploading the quiz will make it available to publish to your classroom. Would you like to continue?", preferredStyle: .alert)
        
        publishAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            let user = Auth.auth().currentUser
            let ref = Database.database().reference().child("Users").child((user!.uid)).child("Uploads")
            ref.updateChildValues([
                    "Quiz Bank": self.quizBank,
                    "Answer Locations": self.aLocations ,
                    "Question Locations": self.qLocations,
                    "View Frames": self.imageFrames
                ])
            if(self.imageContainer.count > 0){
                for img in self.imageContainer{
                    self.uploadImage(img)
                }
            }else{
                print("Empty Image Container")
            }
            self.quizName = ""
        }))
        
        publishAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in}))
        present(quizNameAlert, animated: true, completion: nil)
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
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            imageView.frame = CGRect(x: w / 2, y: h / 2, width: 200, height: 200)
            view.addSubview(imageView)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(self.longPressGesture())
            imageView.addGestureRecognizer(self.movePanGesture())
            imageView.addGestureRecognizer(self.userPinchGesture())
            imageFrames.append(NSStringFromCGRect(imageView.frame))
            pickedImage = pickedImage.resizeWithPercent(percentage: 1.0)!
            imageContainer.append(pickedImage)
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
            print(val!)
            
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
        for index in 0..<25{
            quizBank.append([""])
            for _ in 0..<1{
                quizBank[index].append("")
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
    
    static func removeFromDB(child: String) {
        
        let ref = Database.database().reference()
        
        ref.removeValue { error, _ in
            
            print(error!)
        }
    }
    
    func uploadImage(_ image: UIImage){
        
        let imageName:String = (self.quizName+".png")
        //Store the image in a folder with users id
        let storageRef = Storage.storage().reference().child((Auth.auth().currentUser?.uid)!).child(imageName)
        if let uploadData = UIImagePNGRepresentation(image){
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if error != nil {
                        print("error")
                        return
                    }
                })
            
            }
        }

}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
