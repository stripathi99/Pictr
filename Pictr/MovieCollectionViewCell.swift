//
//  MovieCollectionViewCell.swift
//  Pictr
//
//  Created by Shubham Tripathi on 15/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieActivityIndicator: UIActivityIndicatorView!
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieActivityIndicator.hidesWhenStopped = true
        
        movieImageView.contentMode = UIViewContentMode.ScaleAspectFit
        movieImageView.clipsToBounds = true
    }
}