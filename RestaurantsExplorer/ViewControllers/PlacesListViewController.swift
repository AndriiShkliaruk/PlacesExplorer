//
//  PlacesListViewController.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 23.01.2022.
//

import UIKit

class PlacesListViewController: UITableViewController, UISearchBarDelegate {
    
    private var places = [Place]()
    private var timer: Timer?
    private var placesCategory = ""
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var filterBarButtonItem: UIBarButtonItem = {
        let gearIcon = UIImage(systemName: "text.justifyright")
        return UIBarButtonItem(image: gearIcon, style: .plain, target: self, action: #selector(filterBarButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupSearchBar()
        setupNoResultsLabel()
        setupSpinner()
        
        getPlaces(by: PlacesEndpoint.search(location: Config.location, limit: Config.placesLimit, query: "", category: placesCategory))
        
        
    }
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.title = "Search places"
        navigationItem.rightBarButtonItem = filterBarButtonItem
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
        spinner.startAnimating()
    }
    
    
    
    // MARK: - UITableView Delegate and DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count == 0 {
            noResultsLabel.text = "No results found..."
            noResultsLabel.isHidden = false
        } else {
            noResultsLabel.isHidden = true
        }
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as! PlaceCell
        cell.place = places[indexPath.row]
        return cell
    }
    
    
    // MARK: - UISearchBarDelegate method
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        spinner.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { (_) in
            self.getPlaces(by: PlacesEndpoint.search(location: Config.location, limit: Config.placesLimit, query: searchText, category: self.placesCategory))
        })
    }
    
    @objc func filterBarButtonTapped(_ sender:UIButton!) {
        print("filter")
    }
    
    
    // MARK: - NetworkService method
    
    private func getPlaces(by endpoint: PlacesEndpoint) {
        NetworkService.get(by: endpoint.asURLRequest) { (result: Swift.Result<PlacesResponse, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                self.places = results.places
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
    

}
