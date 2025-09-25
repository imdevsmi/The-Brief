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

final class WeatherService: WeatherAPIServiceProtocol {
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://api.weatherapi.com/v1/"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    // MARK: - Fetch Weather
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "forecast.json")
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: SecureConfig.weatherApiKey),
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "days", value: "1"),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no")]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil, completion: completion)
    }
}
