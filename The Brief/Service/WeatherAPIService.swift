//
//  WeatherAPIService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 22.09.2025.
//

import Foundation

protocol WeatherAPIServiceProtocol {
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}


final class WeatherService: WeatherAPIServiceProtocol {
    
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
    }
}
