//
//  OnAirCell.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import UIKit

class OnAirCell: UICollectionViewCell {
    
    @IBOutlet weak var onAirImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstAirDate: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        imageGradient()
    }
    
    func imageGradient() {
        gradient = CAGradientLayer()
        gradient.frame = onAirImage.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.6, 0.8, 1]
        onAirImage.layer.mask = gradient
    }
    
}
