//
//  PlaceDetailViewController.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 24.01.2022.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    var placeId: String?
    private var place: Place?
    private var placeDetailView: PlaceDetailView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPlace()
        setupNavigationBar()
        setupPlaceDetailView()
    }
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupPlaceDetailView() {
        placeDetailView = PlaceDetailView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(placeDetailView!)
    }
    
    
    //MARK: - NetworkService methods
    
    private func getPlace() {
        guard let id = placeId else { return }
        let endpoint = PlacesEndpoint.detail(id: id)
        
        NetworkService.get(by: endpoint.asURLRequest) { (result: Swift.Result<Place, DataError>) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    self.place = result
                    DispatchQueue.main.async {
                        self.placeDetailView?.place = result
                        self.navigationItem.title = result.name
                    }
                }
            
        }
    }

    


}
