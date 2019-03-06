//
//  gradeBook.swift
//  JSU-Test
//
//  Created by Logan Watkins on 3/5/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit

class gradeBook: UIViewController {
    
    var menuVisable = false;
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
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
    
    
}
