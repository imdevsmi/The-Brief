//
//  PulseVM.swift
//  The Brief
//
//  Created by Sami Gündoğan on 20.09.2025.
//

import Foundation

protocol PulseVMInputProtocol: AnyObject {
    func fetchWeather(for city: String)
    func loadLastCity()
}

final class PulseVM: PulseVMInputProtocol {

    // MARK: - Properties
    weak var output: PulseVCOutputProtocol?
    weak var input: PulseVMInputProtocol?
    
    private let weatherService: WeatherAPIServiceProtocol
    private let financeService: FinanceAPIServiceProtocol
    private let weatherStorage: WeatherManagerProtocol
    private let debounceInterval: TimeInterval = 0.5
    private var debounceWorkItem: DispatchWorkItem?
    
    init(weatherService: WeatherAPIServiceProtocol = WeatherService(), financeService: FinanceAPIServiceProtocol = FinanceAPIService(), storage: WeatherManagerProtocol = WeatherManager()) {
        self.weatherService = weatherService
        self.financeService = financeService
        self.weatherStorage = storage
    }
    // MARK: - fetch Weather
    func fetchWeather(for city: String) {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else { return }

        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.callWeatherAPI(for: trimmedCity)
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    // MARK: - Load last city
    func loadLastCity() {
        let city = weatherStorage.loadCity() ?? "İstanbul"
        fetchWeather(for: city)
    }
    
    private func callWeatherAPI(for city: String) {
        weatherService.fetchWeather(city: city) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                self.weatherStorage.saveCity(response.location.name)
                let iconURL = response.current.condition.icon
                let fixedIconURL = iconURL.hasPrefix("http") ? iconURL : "https:\(iconURL)"
                
                let model = WeatherUIModel(city: response.location.name, temp: "\(Int(response.current.temp_c))°C", condition: response.current.condition.text, iconURL: fixedIconURL)
                
                DispatchQueue.main.async { self.output?.didUpdateWeather(model) }
            case .failure(let error):
                print("Weather fetch error:", error.localizedDescription)
            }
        }
    }
    
    func fetchFinanceData() {
        let pairs = ["EUR/USD", "GBP/USD", "USD/TRY"]
        
        financeService.fetchRates(pairs: pairs) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let models):
                DispatchQueue.main.async { self.output?.didUpdateFinance(models) }
            case .failure(let error):
                print("Finance fetch error:", error)
            }
        }
    }
}
