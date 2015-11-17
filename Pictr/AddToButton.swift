//
//  AddToButton.swift
//  Pictr
//
//  Created by Shubham Tripathi on 15/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class AddToButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = UIColor.whiteColor()
        
        layer.borderColor = titleLabel?.textColor.CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
}
