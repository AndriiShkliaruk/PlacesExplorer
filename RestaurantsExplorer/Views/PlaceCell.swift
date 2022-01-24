//
//  PlaceCell.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 24.01.2022.
//

import UIKit

class PlaceCell: UITableViewCell {
    static let identifier = String(describing: PlaceCell.self)
    
    var place: Place? {
        didSet {
            if let receivedPlace = place {
                placeNameLabel.text = "Name: \(receivedPlace.name)"
                placeAddressLabel.text = "Address: \(receivedPlace.location.address ?? "No address")"
                placeCategoryLabel.text = "Category: \(receivedPlace.categories[0].name)"
            }
        }
    }

    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let placeAddressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let placeCategoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [placeNameLabel, placeAddressLabel, placeCategoryLabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.frame = bounds
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 0, enableInsets: false)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
