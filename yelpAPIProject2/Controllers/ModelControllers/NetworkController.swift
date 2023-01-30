//
//  NetworkManager.swift
//  yelpAPIProject2
//
//  Created by Dominique Strachan on 1/24/23.
//

import UIKit

class NetworkController {
    
    let baseURL = URL(string: "https://api.yelp.com/")
    let versionComponent = "v3"
    static let shared = NetworkController()
    
    func fetchBusiness(type: String,completion: @escaping (Result<YelpData, NetworkError>) -> Void ) {
        
        guard var url = baseURL else {
            completion(.failure(NetworkError.badBaseURL))
            return
        }
        
        url.appendPathComponent(versionComponent)
        url.appendPathComponent("businesses")
        url.appendPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [
            URLQueryItem(name: "term", value: type),
            URLQueryItem(name: "location", value: "25001 Veterans Way, Mission Viejo, CA 92692"),
            URLQueryItem(name: "limit", value: "30")
        ]
        
        //checking for built URL and placing in variable
        guard let builtURL = components?.url else {
            return completion(.failure(.badBaseURL))
        }
        
        var request = URLRequest(url: builtURL)
        
        request.allHTTPHeaderFields = Constants.headers
        
        
        print("[NetworkManager] - \(#function) builtURL: \(builtURL.description)")
        
        //MARK: - URL Session Data Task
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.invalidData(error.localizedDescription)))
                print("error: \(error): \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData(response.debugDescription)))
                return
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let business = try JSONDecoder().decode(YelpData.self, from: data)
                
                return completion(.success(business))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
}


