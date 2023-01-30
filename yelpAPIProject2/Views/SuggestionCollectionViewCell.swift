//
//  SuggestionCollectionViewCell.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/25/23.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func updateViews(business: Business?) {
        guard let business = business else { return }
        nameLabel.text = business.name
        ratingPriceLabel.text = "\(business.rating) \(business.price ?? "")"
    }
    
}
