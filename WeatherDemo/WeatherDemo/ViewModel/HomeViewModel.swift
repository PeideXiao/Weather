//
//  HomeViewModel.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import UIKit

class HomeViewModel: NSObject {
    
    private var _detail: Detail?
    let service: Webservice = Webservice.shared
    var locationService: LocationService?
    var locationCompletion: ((String?) -> Void)?
    
    var detail: Detail? {
        get {
            if _detail != nil { return _detail }
            return UserDefaults.standard.read(for: last_city_searched_key)
        }
        
        set {
            _detail = newValue
            UserDefaults.standard.write(newValue, for: last_city_searched_key)
        }
    }
    
    var isLocationServiceOn: Bool = false {
        didSet {
            self.locationService = LocationService()
            self.locationService!.completion = { [unowned self] location in
                guard let location = location else { return }
                self.fetchWeatherDetail(city: location.name, state: location.state, country: location.country) { [unowned self] error in
                    if let error = error {
                        self.locationCompletion?(error)
                    } else {
                        self.locationCompletion?(nil)
                    }
                }
            }
        }
    }
    
    func fetchWeatherDetail(city: String, state: String?, country: String?, completion: @escaping (String?) -> Void) {
        service.fetchWeatherDetails(city: city, state: state, country: country) { [unowned self] detail, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let obj = detail {
                self.detail = obj
                completion(nil)
            }
        }
    }
}
