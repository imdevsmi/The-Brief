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
            
            networkManager.request(url: url, method: .GET, headers: nil) { (result: Result<TwelveDataQuoteResponse, NetworkError>) in
                switch result {
                case .success(let response):
                    let UiModel = FinanceUIModel(pair: response.symbol, bid: response.bid ?? response.price ?? "-", offer: response.ask ?? response.price ?? "-")
                    results.append(UiModel)
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !errors.isEmpty && results.isEmpty {
                completion(.failure(errors.first!))
            } else {
                completion(.success(results))
            }
        }
    }
}
