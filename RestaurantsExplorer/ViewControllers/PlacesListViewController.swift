//
//  PlacesListViewController.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 23.01.2022.
//

import UIKit

class PlacesListViewController: UITableViewController, UISearchBarDelegate, FilterCategoriesDelegate {
    
    private var places = [Place]()
    private var categories: [FilterCategory]?
    private var timer: Timer?
    private var searchText = ""
    
    
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
        
        loadCategories()
        getPlaces()
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
        //spinner.startAnimating()
    }
    
    
    
    // MARK: - TableView methods
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeDetailViewController = PlaceDetailViewController()
        placeDetailViewController.place = places[indexPath.row]
        navigationController?.pushViewController(placeDetailViewController, animated: true)
    }
    
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { (_) in
            self.searchText = searchText
            self.getPlaces()
        })
    }
    
    
    // MARK: - FilterCategoriesDelegate methods
    
    func set(categories: [FilterCategory]?) {
        self.categories = categories
        getPlaces()
    }
    
    
    //MARK: - User interaction methods
    
    @objc func filterBarButtonTapped(_ sender:UIButton!) {
        let filterCategoriesViewController = FilterCategoriesViewController()
        filterCategoriesViewController.delegate = self
        filterCategoriesViewController.categories = categories
        let navigationController = UINavigationController(rootViewController: filterCategoriesViewController)
        present(navigationController, animated: true)
    }
    
    
    
    // MARK: - NetworkService methods
    
    private func getPlaces() {
        spinner.startAnimating()
        let selectedCategoriesCodes = categories?.filter { $0.selected }.map { $0.code }.joined(separator: ",")

        let endpoint = PlacesEndpoint.search(location: Config.location, limit: Config.placesLimit, query: searchText, categories: selectedCategoriesCodes)
        NetworkService.get(by: endpoint.asURLRequest) { (result: Swift.Result<PlacesResponse, DataError>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let results):
                    self.places = results.places
                    self.tableView.reloadData()
                }
                self.spinner.stopAnimating()
            }
        }
    }
    
    
    
    private func loadCategories() {
        categories = Config.categories.map {
                FilterCategory(name: $0.key, code: $0.value, selected: false)
        }
    }
    

}
