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
    
    weak var output: PulseVCOutputProtocol?
    weak var input: PulseVMInputProtocol?
    
    private let weatherService: WeatherAPIServiceProtocol
    
    init(weatherService: WeatherAPIServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for city: String) {
        weatherService.fetchWeather(city: city) { [weak self] result in
            switch result {
            case .success(let response):
                let model = self?.mapToUIModel(response: response)
                if let model = model {
                    DispatchQueue.main.async {
                        self?.output?.didUpdateWeather(model)
                    }
                }
            case .failure(let error):
                print("Weather fetch error:", error.localizedDescription)
            }
        }
    }
    
    private func mapToUIModel(response: WeatherResponse) -> WeatherUIModel {
        let city = response.location.name
        let temp = "\(Int(response.current.temp_c))°C"
        let condition = response.current.condition.text
        let min = "\(Int(response.forecast.forecastday.first?.day.mintemp_c ?? 0))"
        let max = "\(Int(response.forecast.forecastday.first?.day.maxtemp_c ?? 0))"
        let iconURL = "https:\(response.current.condition.icon)"
        let aqi = response.current.air_quality.us_epa_index
        
        let alerts = response.alerts.alert.map {
            WeatherAlert(headline: $0.headline, severity: $0.severity)
        }
        
        return WeatherUIModel(city: city, temp: temp, condition: condition, min: min, max: max, iconURL: iconURL, airQualityIndex: aqi, alerts: alerts)
    }
}
