//
//  PlacesListViewController.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 23.01.2022.
//

import UIKit
import CoreLocation

class PlacesListViewController: UITableViewController, UISearchBarDelegate {
    
    private let locationManager = CLLocationManager()
    private var places = [Place]()
    private var categories: [FilterCategory]?
    private var searchBarTimer: Timer?
    private var searchText = ""
    private var location = ""
    
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var filterBarButtonItem: UIBarButtonItem = {
        let filterIcon = UIImage(systemName: "text.justifyright")
        return UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(filterBarButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupSearchBar()
        setupNoResultsLabel()
        setupSpinner()
        setupRefreshControl()
        
        spinner.startAnimating()
        
        setupLocationManager()
        loadCategories()
    }
    
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.title = "Places Explorer"
        navigationItem.rightBarButtonItem = filterBarButtonItem
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
    }
    
    private func setupNoResultsLabel() {
        tableView.addSubview(noResultsLabel)
        noResultsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        noResultsLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 150).isActive = true
    }
    
    private func setupSpinner() {
        tableView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor,constant: -((navigationController?.navigationBar.frame.height)! + (navigationItem.searchController?.searchBar.frame.height)!)).isActive = true
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    
    
    //MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultsLabel.isHidden = (places.count != 0)
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as! PlaceCell
        cell.place = places[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeDetailViewController = PlaceDetailViewController()
        placeDetailViewController.placeId = places[indexPath.row].id
        navigationController?.show(placeDetailViewController, sender: self)
    }
    
    
    
    //MARK: - UISearchBarDelegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarTimer?.invalidate()
        searchBarTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { (_) in
            self.searchText = searchText
            self.getPlaces()
        })
    }

    
    
    //MARK: - User interaction methods
    
    @objc private func filterBarButtonTapped(_ sender:UIButton!) {
        let filterCategoriesViewController = FilterCategoriesViewController()
        filterCategoriesViewController.delegate = self
        filterCategoriesViewController.categories = categories
        let navigationController = UINavigationController(rootViewController: filterCategoriesViewController)
        present(navigationController, animated: true)
    }
    
    
    @objc private func callPullToRefresh() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        refreshControl?.endRefreshing()
    }
    
    
    
    //MARK: - NetworkService methods
    
    private func getPlaces() {
        spinner.startAnimating()
        let selectedCategoriesCodes = categories?.filter { $0.selected }.map { $0.code }.joined(separator: ",")

        let endpoint = PlacesEndpoint.search(location: location, limit: Constants.placesLimit, query: searchText, categories: selectedCategoriesCodes)
        NetworkService.get(by: endpoint.asURLRequest) { (result: Swift.Result<PlacesResponse, DataError>) in
            
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let results):
                    DispatchQueue.main.async {
                    if results.places.count == 0 {
                        self.noResultsLabel.text = "No results found..."
                    }
                    self.places = results.places
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                    }
                }
        }
    }
    
    
    //MARK: - Load default categories
    
    private func loadCategories() {
        categories = Constants.categories.map {
                FilterCategory(name: $0.key, code: $0.value, selected: false)
        }
    }
    
}



// MARK: - FilterCategoriesDelegate implementation

extension PlacesListViewController: FilterCategoriesDelegate {
    func set(categories: [FilterCategory]?) {
        guard self.categories != categories else { return }
        self.categories = categories
        getPlaces()
    }
}



// MARK: - CoreLocation methods

extension PlacesListViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = locations.first?.coordinate else { return }
        let locationString = "\(locValue.latitude),\(locValue.longitude)"
        location = locationString
        getPlaces()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
