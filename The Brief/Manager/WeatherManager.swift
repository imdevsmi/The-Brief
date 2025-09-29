//
//  WeatherManager.swift
//  The Brief
//
//  Created by Sami Gündoğan on 29.09.2025.
//

import Foundation

protocol WeatherManagerProtocol {
    func saveCity(_ city: String)
    func loadCity() -> String?
    func clearCity()
}

final class WeatherManager: WeatherManagerProtocol {
    private let key = "lastCity"
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func saveCity(_ city: String) {
        defaults.set(city, forKey: key)
    }
    
    func loadCity() -> String? {
        defaults.string(forKey: key)
    }
    
    func clearCity() {
        defaults.removeObject(forKey: key)
    }
}
