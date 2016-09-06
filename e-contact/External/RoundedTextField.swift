//
//  RoundedTextField.swift
//  e-contact
//
//  Created by Illya on 3/14/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)!
        
        layer.cornerRadius = 4
        layer.borderColor = UIColor.applicationThemeColorShaded().CGColor
        layer.borderWidth = 2
        layer.masksToBounds = true
    }
    
}
