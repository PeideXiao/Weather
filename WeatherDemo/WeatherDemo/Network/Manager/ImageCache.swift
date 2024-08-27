//
//  ImageLoader.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import UIKit

protocol ImageCacheType: AnyObject {
    func image(for url: String) -> UIImage?
    func insertImage(_ image: UIImage?, for url: String)
    func removeImage(_ image: String)
    subscript(_ url: String) -> UIImage? { get set }
}

class ImageCache {
    
    static let shared: ImageCache = ImageCache()
    
    lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    private let lock = NSLock()
}


extension ImageCache: ImageCacheType {
 
    func image(for url: String) -> UIImage? {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        if let image = imageCache.object(forKey: url as NSString) {
            return image
        }
        return nil
    }
    
    func insertImage(_ image: UIImage?, for url: String) {
        guard let image = image else {
            removeImage(url)
            return
        }
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        imageCache.setObject(image, forKey: url as NSString)
    }
    
    func removeImage(_ image: String) {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        imageCache.removeObject(forKey: image as NSString)
    }
    
    subscript(url: String) -> UIImage? {
        get {
            return image(for: url)
        }
        set {
            insertImage(newValue, for: url)
        }
    }
}


