//
//  FinanceAPIService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import Foundation

protocol FinanceAPIServiceProtocol {
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void)
}

final class FinanceAPIService: FinanceAPIServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://api.metalpriceapi.com/v1/latest"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void) {
        let symbols = Set(pairs.flatMap { $0.split(separator: "/").map(String.init) }).joined(separator: ",")
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: SecureConfig.financeApiKey),
            URLQueryItem(name: "base", value: "TRY"),
            URLQueryItem(name: "currencies", value: symbols)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        networkManager.request(url: url, method: .GET, headers: nil) { (result: Result<FinanceRatesResponse, NetworkError>) in
            switch result {
            case .success(let response):
                let models = FinanceUIModel.fromResponse(response, for: pairs)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
