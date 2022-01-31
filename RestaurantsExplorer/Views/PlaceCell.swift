//
//  PlaceCell.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 24.01.2022.
//

import UIKit

class PlaceCell: UITableViewCell {
    static let identifier = String(describing: PlaceCell.self)
    private let cellPadding: CGFloat = 20
    
    var place: Place? {
        didSet {
            if let receivedPlace = place {
                setContentToUIElements(from: receivedPlace)
            }
        }
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let categoryLabel = UILabel()
    private var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI Elements
    
    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel, categoryLabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.frame = bounds
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: cellPadding/2, paddingLeft: cellPadding, paddingBottom: cellPadding/2, paddingRight: cellPadding, width: 0, height: 0, enableInsets: false)
    }
    
    //MARK: - Set content to UI Elements
    
    private func setContentToUIElements(from place: Place) {
        nameLabel.text = place.name
        addressLabel.setupOrHide(prefix: "Address:", suffix: place.location.address)
        categoryLabel.setupOrHide(prefix: "Category:", suffix: place.categories[0].name)
    }
}
