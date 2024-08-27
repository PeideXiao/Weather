//
//  WeatherAPI.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import Foundation

enum WeatherAPI {
    case detail(String, String?, String?)
    case icon(String)
    case geocoding(Double, Double)
}


extension WeatherAPI: EndPointType {
    
    var baseURL: URL {
        switch self {
        case .detail(_, _, _):
            return URL(string: "https://api.openweathermap.org")!
        case .icon( _ ):
            return URL(string: "https://openweathermap.org")!
        case .geocoding(_, _):
            return URL(string: "http://api.openweathermap.org")!
        }
    }
    
    var path: String {
        switch self {
        case .detail(_, _, _):
            return "/data/2.5/weather"
        case .icon(let id):
            return "/img/wn/\(id)@2x.png"
        case .geocoding(_, _):
            return "/geo/1.0/reverse"
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .detail(let city, let state, let country):
            let params: [String: String] = [
                "q": getParameters(city: city, state: state, country: country),
                "appid": api_key
            ]
            return .requestParameters(bodyParameters: nil, urlParameters: params)
        case .icon(_):
            return .request
        case .geocoding(let lat, let lon):
            let params: [String: Any] = [
                "lat": lat,
                "lon": lon,
                "appid": api_key
            ]
            return .requestParameters(bodyParameters: nil, urlParameters: params)
        }
        
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}

extension WeatherAPI {
    func getParameters(city: String, state: String?, country: String?) -> String {
        var value = city
        if let state = state, !state.isEmpty,
           let country = country, !country.isEmpty {
            value.append(", \(state), \(country)")
            return value
        }
        return value
    }
}
