//
//  HomeViewController.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/25/23.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Properties
    let networkController = NetworkController()
    var tally: Int = 0
    
    ////Property Observer and reloading data once the network call has successfully updated the Yelp Data object
    private var yelpData: YelpData? = nil {
        didSet {
            DispatchQueue.main.async {
                self.suggestionCollectionView.reloadData()
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var locationIconImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        fetch()
        updateLocationLabel()
        orderButtonStyle()
        styleElements()
        //Note: - Alternative to notification center would be the protocol and delegate pattern
        ////how to set up with protocol and delegate???
        NotificationCenter.default.addObserver(self, selector: #selector(self.addToOrder(notification:)), name: Notification.Name("addToOrder"), object: nil)
    }
    
    //MARK: - Actions
    @IBAction func orderButtonTapped(_ sender: Any) {
        orderPlaced()
    }
    
    //MARK: - Helper Methods
    func updateLocationLabel() {
        locationLabel.text = "Mission Viejo, CA"
    }
    
    func orderButtonStyle() {
        
        orderButton.layer.cornerRadius = 20
        orderButton.backgroundColor = #colorLiteral(red: 0.9402226806, green: 0.7454299331, blue: 0, alpha: 1)
        orderButton.setTitle(tally > 0 ? "Order Now \(tally)" : "No Orders", for: .normal)
    }
    
    ////comm pattern
    @objc func addToOrder(notification: Notification) {
        tally += 1
        DispatchQueue.main.async {
            self.orderButton.setTitle("Order Now \(self.tally)", for: .normal)
            print("tally: \(self.tally)")
        }
    }
    
    func styleElements() {
        
        orderView.addVerticalGradientLayer()
        orderView.layer.cornerRadius = 15
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func fetch() {
        networkController.fetchBusiness(type: "popular food") { result in
            switch result {
            case .success(let yelpBusiness):
                self.yelpData = yelpBusiness
                //print statement for testing purposes
                print("[MainVC] - fetch:\(yelpBusiness.businesses)")
                for i in yelpBusiness.businesses {
                    print("item:\(i)")
                }
            case .failure(let error):
                self.presentAlert(with: error.errorDescription ?? "Try Again")
            }
        }
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollectionView {
            return CategoryOptions.categories.count
        }
        
        return yelpData?.businesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            let category = CategoryOptions.categories[indexPath.row]
            categoryCell.category = category
                
            return categoryCell
        }
        
        guard let suggestionCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestionCollectionViewCell else { return UICollectionViewCell() }
        
        let business = yelpData?.businesses[indexPath.row]
        suggestionCell.updateViews(business: business)
        suggestionCell.businessImageView.load(yelp: business?.imageURL ?? "")
        
        return suggestionCell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? DetailMenuViewController,
                  
                    //individual restaurants
                  let cell = sender as? SuggestionCollectionViewCell,
                  
                    //total restaurants
                  let indexPath = self.suggestionCollectionView.indexPath(for: cell),
                  
                    //business details from yelpData JSON being held in variable according to section/row
                  let selectedBusiness = yelpData?.businesses[indexPath.row] else { return }
            
            //object being passed over
            destinationVC.business = selectedBusiness
        }
        
        if segue.identifier == "toCategoryTVC" {
            guard let destinationTVC = segue.destination as? CategoryTableViewController,
                  
                    let cell = sender as? CategoryCollectionViewCell,
                  
                    let indexPath = categoryCollectionView.indexPath(for: cell) else { return }
            
            let selectedCategory = CategoryOptions.categories[indexPath.row]
            
            //object being passed over
            destinationTVC.selectedCategory = selectedCategory
        }
    }
    
    
    //MARK: - Driver animation
    func orderPlaced() {
        //will only shake if 0 orders
        guard tally > 0 else {
            DispatchQueue.main.async {
                self.driverImage.shake()
            }
            return
        }
        DispatchQueue.main.async {
            self.animateOffScreen(imageView: self.driverImage)
        }
    }
}//end of class

extension HomeViewController {
    
    //animateOffScreen animation function
    func animateOffScreen(imageView: UIImageView) {
        let originalCenter = imageView.center
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                imageView.center.x -= 80.0
                imageView.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: -.pi / 80)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                imageView.center.x -= 100.0
                imageView.center.y += 50.0
                imageView.alpha = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
                imageView.transform = .identity
                imageView.center = CGPoint(x:  900.0, y: 100.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                imageView.center = originalCenter
                imageView.alpha = 1.0
            }
            
        }, completion: { (_) in
            self.tally = 0
            self.orderButton.setTitle("No Orders", for: .normal)
        })
    }
}
