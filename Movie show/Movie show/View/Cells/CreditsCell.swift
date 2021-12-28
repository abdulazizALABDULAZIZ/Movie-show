//
//  CreditsCell.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import UIKit

class CreditsCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        imageView.makeRounded()
    }
    
}
