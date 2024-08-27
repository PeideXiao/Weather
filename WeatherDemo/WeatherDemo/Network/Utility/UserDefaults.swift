//
//  UserDefaults.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/27/24.
//

import Foundation

extension UserDefaults {
    func write<T: Codable>(_ value: T, for key: String) {
        do {
            let data: Data = try JSONEncoder().encode(value)
            set(data, forKey: key)
        } catch {
            print("Write error: \(error)")
        }
    }
    
    func read(for key: String) -> Detail? {
        do {
            if let data = value(forKey: key) as? Data {
                return try JSONDecoder().decode(Detail.self, from: data)
            }
        } catch {
            print("Read error: \(error)")
        }
        return nil
    }
}


extension Double {
    func kelvinToFahrenheit() -> String {
        let mf = MeasurementFormatter()
        mf.unitOptions = .providedUnit
        mf.numberFormatter.maximumFractionDigits = 0
        let input = Measurement(value: self, unit: UnitTemperature.kelvin)
        let output = input.converted(to: .fahrenheit)
        return mf.string(from: output)
    }
}
