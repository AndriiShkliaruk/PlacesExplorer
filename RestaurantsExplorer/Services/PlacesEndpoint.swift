//
//  PlacesEndpoint.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 22.01.2022.
//

import Foundation

enum PlacesEndpoint {
    case search(location: String, limit: String, query: String?, categories: String?)
    case detail(id: String)
    
    var asURLRequest: URLRequest {
        get {
            switch self {
            case .detail(let id):
                let parameters = ["fields": "fsq_id,name,location,categories,description,rating,photos"]
                return buildURLRequest(from: "\(Constants.EndpointPath.detail + id)", with: parameters)
                
            case .search(let location, let limit, let query, let categories):
                var parameters = ["ll": location, "limit": limit]
                if let query = query { parameters["query"] = query }
                if let selectedCategories = categories { parameters["categories"] = selectedCategories }
                return buildURLRequest(from: Constants.EndpointPath.search, with: parameters)
            }
        }
    }
    
    private func buildURLRequest(from path: String, with parameters: [String: String]) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.hostURL
        components.path = path
        
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)}
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(Constants.apiKey, forHTTPHeaderField: Constants.HTTPHeaderField.authentication.rawValue)

        return urlRequest
    }
    
}


