//
//  assignments.swift
//  JSU-Test
//
//  Created by Dinorah Bernardini on 3/9/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit

class assignments: UIViewController {
    
    var menuVisable = false;
  
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    
 
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
    
    
}
