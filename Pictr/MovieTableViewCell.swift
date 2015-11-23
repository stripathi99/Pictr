//
//  MovieTableViewCell.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //@IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = UIColor.blackColor()
        selectedBackgroundView = backgroundView
        
        //moviePosterImageView.contentMode = UIViewContentMode.ScaleAspectFit
        //moviePosterImageView.clipsToBounds = true
    }
}