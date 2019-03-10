//
//  rosterController.swift
//  JSU-Test
//
//  Created by Logan Watkins on 2/20/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class rosterController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var rosterArray = [String]()
    @IBOutlet weak var textField: UITextField!
    
    var menuVisable = false;
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    
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
    
    @IBAction func addStudents(_ sender: UIButton) {
        if(textField.text != ""){
            self.rosterArray.append(textField.text!)
            self.tableView.reloadData()
            textField.text = ""
        }
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        presentStoryboard(boardName: "MainInstructor")
    }
    
    
    
    
    func presentStoryboard(boardName: String){
        let storyboard:UIStoryboard = UIStoryboard(name: boardName, bundle: nil)
        let loggedInVC:UIViewController = storyboard.instantiateViewController(withIdentifier: boardName)
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = rosterArray[indexPath.row]
        return cell
    }
    
    
    
}

