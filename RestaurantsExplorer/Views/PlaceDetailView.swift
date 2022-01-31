//
//  PlaceDetailView.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 25.01.2022.
//

import UIKit
import ImageSlideshow

class PlaceDetailView: UIView {
    
    var place: Place? {
        didSet {
            if let receivedPlace = place {
                setContentToUIElements(from: receivedPlace)
            }
        }
    }
    
    private let scrollView = UIScrollView()
    
    private let imageSlideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = .scaleAspectFill
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
        label.font = .systemFont(ofSize: 24, weight: .bold)
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
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupStackView()
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Setup UI Elements
    
    private func setupStackView() {
        let labels = [imageSlideshow, nameLabel, descriptionLabel, addressLabel, localityLabel, categoriesLabel, ratingLabel]
        stackView = UIStackView(arrangedSubviews: labels)
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
    }
    
    private func setupUIElements() {
        addSubview(scrollView)
        scrollView.addSubview(imageSlideshow)
        scrollView.addSubview(stackView)
        
        scrollView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        imageSlideshow.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: stackView.topAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: frame.width, height: frame.width, enableInsets: false)
        stackView.anchor(top: imageSlideshow.bottomAnchor, left: leftAnchor, bottom: scrollView.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: false)
    }
    
    
    //MARK: - Set content to UI Elements
    
    private func setContentToUIElements(from place: Place) {
        if let photos = place.photos, !photos.isEmpty {
            imageSlideshow.setImageInputs(
                photos.map { photo in
                    AlamofireSource(urlString: "\(photo.prefix)800x800\(photo.suffix)", placeholder: nil)!
                })
        } else {
            let image = UIImage(named: "no-image")
            imageSlideshow.setImageInputs([ImageSource(image: image!)])
        }
        
        let categoriesString = place.categories.map { $0.name }.joined(separator: ", ")
        let ratingString = place.rating != nil ? String(place.rating!) : nil
        
        nameLabel.text = place.name
        descriptionLabel.setupOrHide(prefix: nil, suffix: place.description)
        addressLabel.setupOrHide(prefix: "Address:", suffix: place.location.address)
        localityLabel.setupOrHide(prefix: "Locality:", suffix: place.location.locality)
        categoriesLabel.setupOrHide(prefix: "Categories:", suffix: categoriesString)
        ratingLabel.setupOrHide(prefix: "Rating:", suffix: ratingString)
    }
    
}
