//
//  PlaceDetailView.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 25.01.2022.
//

import UIKit
import ImageSlideshow

class PlaceDetailView: UIView {
    
    private let noDataInfo = "No data"
    
    var place: Place? {
        didSet {
            if let receivedPlace = place {
                configureUIElements(with: receivedPlace)
            }
        }
    }
    
    
    private let imageSlideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.activityIndicator = DefaultActivityIndicator(style: .large, color: .gray)
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.black
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageIndicator
        return slideshow
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let addressLabel = UILabel()
    private let localityLabel = UILabel()
    private let categoriesLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(imageSlideshow)
        
        let labels = [nameLabel, descriptionLabel, addressLabel, localityLabel, categoriesLabel, ratingLabel]
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        addSubview(stackView)
        
        imageSlideshow.anchor(top: topAnchor, left: leftAnchor, bottom: stackView.topAnchor, right: rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: frame.width, height: frame.width, enableInsets: false)
        stackView.anchor(top: imageSlideshow.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 50, paddingRight: 15, width: 0, height: 0, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUIElements(with place: Place) {
        if let photos = place.photos {
            imageSlideshow.setImageInputs(
                photos.map { photo in
                    AlamofireSource(urlString: "\(photo.prefix)800x800\(photo.suffix)", placeholder: nil)!
                })
        }
        
        nameLabel.text = "Name: \(place.name)"
        descriptionLabel.text = "Description: \(place.description ?? noDataInfo)"
        addressLabel.text = "Address: \(place.location.address ?? noDataInfo)"
        localityLabel.text = "Locality: \(place.location.locality ?? noDataInfo)"
        categoriesLabel.text = "Categories: \(place.categories.map { $0.name }.joined(separator: ", "))"
        ratingLabel.text = "Rating: \(place.rating != nil ? String(place.rating!) : noDataInfo)"
    }
    
    
}
