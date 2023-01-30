//
//  CategoryCollectionViewCell.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/26/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Lifecycles
    func updateViews() {
        guard let category = category else { return }
        categoryImage.image = UIImage(named: category.imageName)
        categoryLabel.text = category.title
    }
    
    //MARK: - Outlets
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
}
