//
//  FinanceAPIService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import Foundation

// MARK: - Finance API Service Protocol
protocol FinanceAPIServiceProtocol {
    func fetchRates(pairs: [String], completion: @escaping (Result<FinanceRatesResponse, NetworkError>) -> Void)
}

final class FinanceAPIService: FinanceAPIServiceProtocol {
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://direct-demo.currencycloud.com/v2/"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    func fetchRates(pairs: [String], completion: @escaping (Result<FinanceRatesResponse, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "rates/find")
        urlComponents?.queryItems = [URLQueryItem(name: "currency_pair", value: pairs.joined(separator: ","))]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let headers = ["X-Auth-Token": SecureConfig.financeApiKey, "Content-Type": "application/json"]
        networkManager.request(url: url, method: .GET, headers: headers, completion: completion)
    }
}
