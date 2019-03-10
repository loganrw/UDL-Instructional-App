//
//  instructorInfo.swift
//  JSU-Test
//
//  Created by Dinorah Bernardini on 3/8/19.
//  Copyright © 2019 Logan Watkins. All rights reserved.
//

import Foundation
import UIKit

class instructorInfo: UIViewController {
    
    var menuVisable = false;
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
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
    
    
}
