//
//  PlaceDetailViewController.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 24.01.2022.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    var place: Place?
    let placeDetailView = PlaceDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPlace()
        

        view = placeDetailView
        
        
    }
    
    
    // MARK: - NetworkService methods
    
    private func getPlace() {
        guard let id = place?.id else { return }
        let endpoint = PlacesEndpoint.detail(id: id)
        
        NetworkService.get(by: endpoint.asURLRequest) { (result: Swift.Result<Place, DataError>) in
            
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    self.place = result
                    DispatchQueue.main.async {
                        self.placeDetailView.place = result
                        self.navigationItem.title = result.name
                    }
                }
            
        }
    }

    


}
