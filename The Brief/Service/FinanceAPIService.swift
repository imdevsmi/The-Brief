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
            
        }
    }
}
