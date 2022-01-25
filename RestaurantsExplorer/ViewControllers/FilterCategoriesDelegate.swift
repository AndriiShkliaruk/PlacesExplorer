//
//  FilterCategoriesDelegate.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 25.01.2022.
//

import Foundation

protocol FilterCategoriesDelegate: AnyObject {
    func set(categories: [FilterCategory]?)
}
