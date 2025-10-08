//
//  FinanceAPIService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import Foundation

// MARK: - Finance API Service Protocol
protocol FinanceAPIServiceProtocol {
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void)
}

final class FinanceAPIService: FinanceAPIServiceProtocol {
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let apiKey = SecureConfig.financeApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
    private let baseURL = "https://data.fixer.io/api/latest"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void) {
        var allCurrencies = Set<String>()
        for pair in pairs {
            let components = pair.split(separator: "/").map(String.init)
            if components.count == 2 {
                if components[0] != "EUR" { allCurrencies.insert(components[0]) }
                if components[1] != "EUR" { allCurrencies.insert(components[1]) }
            }
        }
        
        let symbols = allCurrencies.joined(separator: ",")
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "access_key", value: apiKey),
            URLQueryItem(name: "symbols", value: symbols)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil) { (result: Result<FinanceRatesResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let models: [FinanceUIModel] = pairs.compactMap { pair in
                    let components = pair.split(separator: "/").map(String.init)
                    guard components.count == 2 else { return nil }
                    
                    let base = components[0]
                    let quote = components[1]
                    let rate: Double
    
                    if base == "EUR" {
                        guard let r = response.rates[quote] else { return nil }
                        rate = r
                    }
                    else if quote == "EUR" {
                        guard let r = response.rates[base] else { return nil }
                        rate = 1.0 / r
                    }
                    else {
                        guard let baseRate = response.rates[base],
                                let quoteRate = response.rates[quote] else { return nil }
                        rate = quoteRate / baseRate
                    }
                    
                    let formattedRate = String(format: "%.4f", rate)
                    return FinanceUIModel(pair: pair, bid: formattedRate, offer: formattedRate)
                }
                completion(.success(models))
                
            case .failure(let error):
                print("❌ Error:", error)
                completion(.failure(error))
            }
        }
    }
}
