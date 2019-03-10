//
//  quizViewController.swift
//  JSU-Test
//
//  Created by acns on 12/15/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class quizViewController: UIViewController {


    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var answer0: UIButton!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func subAnswer0(_ sender: UIButton) {
        checkAnswer(idx: 0)
    }
    
    @IBAction func subAnswer1(_ sender: UIButton) {
        checkAnswer(idx: 1)
    }
    
    @IBAction func subAnswer2(_ sender: UIButton) {
        checkAnswer(idx: 2)
    }
    
    @IBAction func subAnswer3(_ sender: UIButton) {
        checkAnswer(idx: 3)
    }
    
    
    struct Question {
        let question: String
        let answers: [String]
        let correctAnswer: Int
    }
    
    
    var questions: [Question] = [
        Question(
            question: "What is 1+1?",
            answers: ["1", "2", "3", "4"],
            correctAnswer: 1),
        Question(
            question: "Is my app working well?",
            answers: ["Yes", "No", "Some Flaws", "A lot of flaws"],
            correctAnswer: 0),
        Question(
            question: "What planet is farthest from earth?",
            answers: ["The Sun", "Saturn", "Pluto", "Mars"],
            correctAnswer: 2)
    ]
    
    var currentQuestion: Question?
    var currentQuestionPos = 0
    
    var noCorrect = 0
    
    func checkAnswer(idx: Int) {
        if(idx == currentQuestion?.correctAnswer) {
            noCorrect += 1
        }
        loadNextQuestion()
    }
    
    var menuVisable = false;
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
  
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if(!menuVisable){
            leadingC.constant = 250
            trailingC.constant = -250
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
    //Reloads the quiz view
    @IBAction func quizButtonPressed(_ sender: UIButton) {
        self.presentStoryboard(boardName: "quizView")
    }

    @IBAction func logOutPressed(_ sender: UIButton) {
            self.presentStoryboard(boardName: "logInView")
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        self.presentStoryboard(boardName: "studentLogIn")
    }
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }

    func setQuestion() {
        questionField.text = currentQuestion!.question
        answer0.setTitle(currentQuestion!.answers[0], for: .normal)
        answer1.setTitle(currentQuestion!.answers[1], for: .normal)
        answer2.setTitle(currentQuestion!.answers[2], for: .normal)
        answer3.setTitle(currentQuestion!.answers[3], for: .normal)
        progressLabel.text = "\(currentQuestionPos + 1) / \(questions.count)"
    }
    
    func loadNextQuestion() {
        // Show next question
        if(currentQuestionPos + 1 < questions.count) {
            currentQuestionPos += 1
            currentQuestion = questions[currentQuestionPos]
            setQuestion()
            // If there are no more questions show the results
        } else {
            let score = String(describing: noCorrect)
            let total = String(describing: questions.count)
            let alert = UIAlertController(title: "Quiz Results", message: "Score: "+score + " / "+total, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestion = questions[0]
        setQuestion()
    }
    

}
