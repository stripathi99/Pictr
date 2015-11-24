//
//  MovieListSegmentControl.swift
//  Pictr
//
//  Created by Shubham Tripathi on 24/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class MovieListSegmentControl: UISegmentedControl {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = UIColor.whiteColor()
        
        setBackgroundImage(UIImage(named: "segmentedControlBackgroundNormal"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        setBackgroundImage(UIImage(named: "segmentedControlBackgroundSelected"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
    }
}