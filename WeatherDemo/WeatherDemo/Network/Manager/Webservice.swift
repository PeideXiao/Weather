//
//  Webservice.swift
//  NetWorkLayer
//
//  Created by Peide Xiao on 10/30/23.
//  Copyright © 2023 Peide Xiao. All rights reserved.
//

import UIKit

struct Webservice {
    static let shared: Webservice = Webservice();
    private let router = Router<WeatherAPI>()
    
    func fetchWeatherDetails(city: String, state: String?, country: String?, completion: @escaping (_ detail: Detail?, _ error: String?) -> Void) {
        router.request(.detail(city, state, country)) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkError.failedRequest.rawValue)
                return
            }
            
            switch handleNetworkResponse(response) {
            case .success:
                guard let data = data else {
                    completion(nil, NetworkError.noData.rawValue)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Detail.self, from: data)
                    completion(result, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func loadWeatherIcon(id: String, completion: @escaping (_ image: UIImage?, _ error: String?) -> Void) {
        router.request(.icon(id)) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkError.failedRequest.rawValue)
                return
            }
            
            switch response.statusCode {
            case 200:
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image, nil)
                    return
                }
                completion(nil, NetworkError.failedRequest.rawValue)
            default:
                completion(nil, NetworkError.failedRequest.rawValue)
            }
        }
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping ([Location]?, String?) -> Void) {
        router.request(.geocoding(latitude, longitude)) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkError.failedRequest.rawValue)
                return
            }
            
            switch handleNetworkResponse(response) {
            case .success:
                guard let data = data else {
                    completion(nil, NetworkError.noData.rawValue)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([Location].self, from: data)
                    completion(result, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200: return .success
        case 400: return .failure(NetworkError.failedRequest.rawValue)
        case 401: return  .failure(NetworkError.invalidAPIKey.rawValue)
        case 404: return .failure(NetworkError.noData.rawValue)
        default: return .failure(NetworkError.failedRequest.rawValue);
        }
    }
}


