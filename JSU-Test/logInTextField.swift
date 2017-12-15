//
//  logInTextField.swift
//  JSU-Test
//
//  Created by acns on 12/13/17.
//  Copyright © 2017 Logan Watkins. All rights reserved.
//

import UIKit

@IBDesignable
class logInTextField: UITextField {

    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.layer.borderColor = UIColor(white: 231/255, alpha: 1).cgColor
        layer.borderWidth = 1
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
