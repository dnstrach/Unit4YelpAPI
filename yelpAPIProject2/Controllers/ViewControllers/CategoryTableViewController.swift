//
//  CategoryTableViewController.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/27/23.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    //MARK: - Properties
    var selectedCategory: Category?
    var yelpData: YelpData? = nil {
            didSet {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        
    }
    
    //MARK: - Helper Methods
    func fetch() {
        NetworkController.shared.fetchBusiness(type: selectedCategory?.title ?? "food") { results in
            switch results {
            case .success(let data):
                self.yelpData = data
            case .failure(let error):
                self.presentAlert(with: error.errorDescription ?? "Try Again")
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yelpData?.businesses.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath)
        
        guard let business = yelpData?.businesses[indexPath.row] else { return UITableViewCell() }
        
        var content = cell.defaultContentConfiguration()
        
        content.text = business.name
        
        content.secondaryText = "\(business.rating)"
        
        content.image = UIImage(named: selectedCategory?.imageName ?? "")
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailMenuVC = segue.destination as? DetailMenuViewController,
              let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        let business = yelpData?.businesses[indexPath.row]
        detailMenuVC.business = business
    }
    
}
