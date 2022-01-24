//
//  NetworkService.swift
//  RestaurantsExplorer
//
//  Created by Andrii Shkliaruk on 22.01.2022.
//

import Foundation

class NetworkService {
    typealias Completion<T> = (Swift.Result<T, DataError>) -> Void
    
    static func get<T: Decodable>(by urlRequest: URLRequest, completion: @escaping Completion<T>) {
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            }catch {
                completion(.failure(.decoding))
            }
        }.resume()
    }
    

}


enum DataError: Error {
    case network(Error)
    case invalidResponse
    case invalidData
    case decoding
}
