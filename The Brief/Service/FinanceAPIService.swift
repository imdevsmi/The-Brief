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
    
    private let networkManager: NetworkManagerProtocol
    private let apiKey = SecureConfig.financeApiKey
    private let baseURL = "https://data.fixer.io/api/latest"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void) {
        let symbols = pairs
            .flatMap { $0.split(separator: "/").map(String.init) }
            .filter { $0 != "USD" }
            .joined(separator: ",")
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "access_key", value: apiKey),
            URLQueryItem(name: "base", value: "USD"),
            URLQueryItem(name: "symbols", value: symbols)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil) { (result: Result<FinanceRatesResponse, NetworkError>) in
            switch result {
            case .success(let response):
                print("✅ Fixer API response:", response.rates)
                
                let models = pairs.compactMap { pair -> FinanceUIModel? in
                    let components = pair.split(separator: "/").map(String.init)
                    guard components.count == 2 else { return nil }
                    
                    let base = components[0]
                    let quote = components[1]
                    guard let rate = response.rates[base] ?? response.rates[quote] else { return nil }
                    
                    let displayRate: Double
                    if quote == response.base {
                        displayRate = 1.0 / rate
                    } else {
                        displayRate = rate
                    }
                    
                    return FinanceUIModel(pair: pair, bid: String(format: "%.4f", displayRate), offer: String(format: "%.4f", displayRate))
                }
                completion(.success(models))
            case .failure(let error):
                print("api dont response", error)
                completion(.failure(error))
            }
        }
    }
}
