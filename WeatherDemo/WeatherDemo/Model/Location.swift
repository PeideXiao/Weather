//
//  Location.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import UIKit


struct Location: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String
}
