//
//  NetworkError.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/24/23.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badBaseURL
    case badBuiltURL
    case invalidData(String)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .badBaseURL:
            return NSLocalizedString("Issue with base URL.", comment: "")
            
        case .badBuiltURL:
            return NSLocalizedString("Issue with URL.", comment: "")
            
        case .invalidData:
            return NSLocalizedString("Issue with data from API call.", comment: "")
            
        case .noData:
            return "The server responded with no data."
            
        case .unableToDecode:
            return "unable to decode"
        }
    }
}


