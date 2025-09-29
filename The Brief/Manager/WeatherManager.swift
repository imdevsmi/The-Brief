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
    func saveCity(_ city: String) {
        
    }
    
    func loadCity() -> String? {
        
    }
    
    func clearCity() {
        
    }
}
