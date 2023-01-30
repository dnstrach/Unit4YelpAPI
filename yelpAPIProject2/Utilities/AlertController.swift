//
//  AlertController.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/27/23.
//

import UIKit

class AlertController {
    static func presentAlertControllerWith(alertTitle: String, alertMessage: String?, dismissActionTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissActionTitle, style: .cancel)
        alertController.addAction(dismissAction)
        
        return alertController
    }
}
