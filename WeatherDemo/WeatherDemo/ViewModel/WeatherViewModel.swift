//
//  WeatherViewModel.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import Foundation
import UIKit


class WeatherViewModel {
    let imageLoader: ImageLoader = ImageLoader()
    
    func loadImage(id: String, completion: @escaping (UIImage) -> Void) {
        imageLoader.loadImage(id: id) { image in
            completion(image ?? UIImage(systemName: "sun.min")!.withTintColor(.lightGray, renderingMode: .alwaysTemplate))
        }
    }
    
}
