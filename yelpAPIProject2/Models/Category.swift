//
//  Category.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/27/23.
//

import Foundation

struct Category {
    
    var title: String
    var imageName: String
}

struct CategoryOptions {
    
    static var categories: [Category] = [
        Category(title: "Pasta", imageName: "pasta"),
        Category(title: "Pizza", imageName: "pizza"),
        Category(title: "Burger", imageName: "burger"),
        Category(title: "Tacos", imageName: "taco"),
        Category(title: "Pho", imageName: "pho"),
        Category(title: "Sushi", imageName: "sushi"),
        Category(title: "Coffee", imageName: "coffee"),
        Category(title: "Boba", imageName: "boba")
    ]
}
