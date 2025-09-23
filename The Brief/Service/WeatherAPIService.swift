//
//  WeatherAPIService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 22.09.2025.
//

import Foundation

// MARK: - Weather API Service Protocol
protocol WeatherAPIServiceProtocol {
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}

// MARK: -Weather Service
final class WeatherService: WeatherAPIServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://api.weatherapi.com/v1/"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    // MARK: - Fetch Weather
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
    }
}
