//
//  Config.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 22.01.2022.
//

import Foundation
import UIKit

struct Constants {
    static let hostURL: String = "api.foursquare.com"
    
    struct EndpointPath {
        static let search = "/v3/places/search"
        static let detail = "/v3/places/"
    }

    static let placesLimit = String(30)

    static let apiKey = "fsq3FUhRLc6rTsoOowg+MfPk5iG0h1kcv6IITzTFO2LO6uo="
    
    static let categories = [
        "Arts and Entertainment": "10000",
        "Business and Professional Services": "11000",
        "Community and Government": "12000",
        "Dining and Drinking": "13000",
        "Event": "14000",
        "Health and Medicine": "15000",
        "Landmarks and Outdoors": "16000",
        "Retail": "17000",
        "Sports and Recreation": "18000",
        "Travel and Transportation": "19000"
    ]
    
    
    enum HTTPHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
    }

    enum ContentType: String {
        case json = "application/json"
    }
    
}
