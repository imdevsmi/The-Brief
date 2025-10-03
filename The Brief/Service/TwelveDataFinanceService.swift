//
//  TwelveDataFinanceService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 3.10.2025.
//

import Foundation

final class TwelveDataFinanceService: FinanceAPIServiceProtocol{
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://api.twelvedata.com"
    private let apiKey = SecureConfig.twelveDataApiKey
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void) {
        let group = DispatchGroup()
        var results: [FinanceUIModel] = []
        var errors: [NetworkError] = []
        
        for pair in pairs {
            group.enter()
            var urlComponents = URLComponents(string: baseURL + "/quote")
            urlComponents?.queryItems = [URLQueryItem(name: "symbol", value: pair), URLQueryItem(name: "apikey", value: apiKey)]
            
            guard let url = urlComponents?.url else {
                errors.append(.invalidRequest)
                group.leave()
                continue
            }
        }
    }
}
