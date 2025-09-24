//
//  PulseVM.swift
//  The Brief
//
//  Created by Sami Gündoğan on 20.09.2025.
//

import Foundation

protocol PulseVMInputProtocol: AnyObject {
    func fetchWeather(for city: String)
}

final class PulseVM: PulseVMInputProtocol {
    
    private unowned let output: PulseVCOutputProtocol
    private let weatherService: WeatherAPIServiceProtocol
    
    init(output: PulseVCOutputProtocol, weatherService: WeatherAPIServiceProtocol = WeatherService()) {
        self.output = output
        self.weatherService = weatherService
    }
    
    func fetchWeather(for city: String) {
        
    }
}
