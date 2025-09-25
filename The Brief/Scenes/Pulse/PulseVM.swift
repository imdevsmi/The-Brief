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
    private let debounceInterval: TimeInterval = 0.5
    private var debounceWorkItem: DispatchWorkItem?

    init(weatherService: WeatherAPIServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

    
    func fetchWeather(for city: String) {
        print("FetchWeather called for city:", city)

        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else { return }

        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.callWeatherAPI(for: trimmedCity)
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }

    private func callWeatherAPI(for city: String) {
        weatherService.fetchWeather(city: city) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                let iconURL = response.current.condition.icon
                let fixedIconURL = iconURL.hasPrefix("http") ? iconURL : "https:\(iconURL)"
                
                let model = WeatherUIModel(
                    city: response.location.name,
                    temp: "\(Int(response.current.temp_c))°C",
                    condition: response.current.condition.text,
                    iconURL: fixedIconURL
                )
                
                DispatchQueue.main.async {
                    self.output?.didUpdateWeather(model)
                }
            case .failure(let error):
                print("Weather fetch error:", error.localizedDescription)
            }
        }
    }
}
