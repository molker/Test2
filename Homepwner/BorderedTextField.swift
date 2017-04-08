//
//  BorderedTextField.swift
//  Homepwner
//
//  Created by Matthew Olker on 3/27/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        borderStyle = .bezel
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        borderStyle = .roundedRect
        return true
    }
}
