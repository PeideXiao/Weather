//
//  ImageLoader.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import UIKit

class ImageLoader {
    
    let service: Webservice = Webservice.shared
    
    func loadImage(id: String, completion: @escaping (UIImage?) -> Void) {
        let urlString: String = image_url_pre_key + id + image_url_suf_key
        if let image = ImageCache.shared[urlString] {
            completion(image)
            return
        }
        
        service.loadWeatherIcon(id: id) { (image, error) in
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let image = image else {
                completion(nil)
                return
            }
            
            ImageCache.shared[urlString] = image
            completion(image)
            return
        }
        completion(nil)
    }
}
