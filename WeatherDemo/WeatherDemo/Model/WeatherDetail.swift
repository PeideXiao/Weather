//
//  WeatherDetail.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import Foundation

struct Detail: Codable {
    let cod: Int
    let id: Int
    let name: String
    let dt: Int
    let timezone: TimeInterval
    let main: Temperature
    let weather: [Condition]
    
    var primaryWeather: Condition? {
        return weather.first
    }
    
    var date: String? {
        let date = Date(timeIntervalSince1970: Double(self.dt))
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(secondsFromGMT: Int(timezone))
        return formatter.string(from: date)
    }
}


struct Condition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct Temperature: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
