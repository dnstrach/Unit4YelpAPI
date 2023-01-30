//
//  DetailMenuViewController.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/26/23.
//

import UIKit
import MapKit

class DetailMenuViewController: UIViewController {
    
    //MARK: - Properties
    ////receiver
    var business: Business?
    
    //MARK: - Outlets
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var seeAllPhotosLabel: UILabel!
    @IBOutlet weak var priceCategoryLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var phoneNumButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        addToCartButtonStyle()
    }
    
    //MARK: Helper Methods
    func updateViews() {
        guard let business = business else { return }
        
        businessImageView.load(yelp: business.imageURL ?? "")
        
        nameLabel.text = "\(business.name)"
        nameLabel.textColor = .white
        nameLabel.shadowColor = .black
        priceCategoryLabel.text = "\(business.price ?? "") \(business.categories.map({$0.title}).joined(separator: ", "))"
        
        ratingLabel.text = "\(setStars(rating: business.rating)) - \(business.reviewCount)"
        ratingLabel.textColor = .white
        
        seeAllPhotosLabel.textColor = .white
        
        isOpenLabel.text = "Open Now"
    }
    
    func addToCartButtonStyle() {
        addToCartButton.layer.cornerRadius = 30
    }
    
    func setStars(rating: Double) -> String {
        
        var starRating: String = ""
        switch rating.rounded(.towardZero) {
        case 1:
            starRating = "⭐️"
        case 2: starRating = "⭐️⭐️"
        case 3: starRating = "⭐️⭐️⭐️"
        case 4: starRating = "⭐️⭐️⭐️⭐️"
        case 5: starRating = "⭐️⭐️⭐️⭐️⭐️"
        default:
            break
        }
        
        if floor(rating) != rating {
            starRating.append(contentsOf: "1/2")
        }
        
        return starRating
    }
    
    //MARK: - Actions
    
    @IBAction func xButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("addToOrder"), object: nil)
    }
    
    
    @IBAction func callButtonPressed(_ sender: Any) {
        guard let business = business else { return }
        
        if let url = URL(string: "tel://\(business.phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
            
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    let phoneNotAvailable = AlertController.presentAlertControllerWith(alertTitle: "Unable to place call", alertMessage: "Ensure you are on a physical device that allows phone calls and not an Xcode simulator", dismissActionTitle: "Dismiss")
                    DispatchQueue.main.async {
                        self.present(phoneNotAvailable, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        guard let business = business else { return }

        guard let myAddress = business.location?.displayAddress.joined(separator: " ") else { return }

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(myAddress) { (placemarks, error) in
            guard let placemarks = placemarks?.first else { return }
            let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
            guard let url = URL(string:"http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func reviewsButtonPressed(_ sender: Any) {
        guard let business = business else {
            return
        }
        
        if let url = URL(string: business.url) {
            UIApplication.shared.open(url)
        } else {
            let phoneNotAvailable = AlertController.presentAlertControllerWith(alertTitle: "Unable to complete request", alertMessage: "Please try again later", dismissActionTitle: "Dismiss")
            DispatchQueue.main.async {
                self.present(phoneNotAvailable, animated: true)
            }
        }
    }
    
} // end of class
