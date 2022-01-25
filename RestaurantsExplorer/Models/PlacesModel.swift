//
//  PlacesModel.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 19.01.2022.
//

import Foundation

struct PlacesResponse: Decodable {
    let places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case places = "results"
    }
}

struct Place: Decodable {
    let id: String
    let name: String
    let location: Location
    let categories: [Category]
    let description: String?
    let rating: Double?
    let photos: [PlacePhoto]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name, location, categories, description, rating, photos
    }
    
    struct Category: Decodable {
        let name: String
    }

    struct Location: Decodable {
        let address: String?
        let locality: String?
        let country: String
    }
    
    struct PlacePhoto: Decodable {
        let prefix: String
        let suffix: String
    }
}
