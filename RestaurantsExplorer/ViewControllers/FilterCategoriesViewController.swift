//
//  FilterViewController.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 25.01.2022.
//

import UIKit

class FilterCategoriesViewController: UITableViewController {
    
    var categories: [FilterCategory]?
    weak var delegate: FilterCategoriesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.set(categories: categories)
    }
    
    
    //MARK: - Setup UI Elements
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Select categories"
    }
    
   

    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if let category = categories?[indexPath.row] {
            var content = cell.defaultContentConfiguration()
            content.text = category.name
            cell.contentConfiguration = content
            cell.accessoryType = category.selected ? .checkmark : .none
            cell.tintColor = .black
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categories?[indexPath.row].selected.toggle()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }



}
