//
//  LocationService.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    var locationManager: CLLocationManager?
    let webService: Webservice = Webservice.shared
    var completion: ((Location?) -> Void)?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        locationManager!.requestWhenInUseAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .denied:
            print("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorizedAlways")
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil

        webService.geocode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { [weak self] locations, error in
            guard let locations = locations else { return }
            self?.completion?(locations.first)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        assertionFailure(error.localizedDescription)
    }
}
