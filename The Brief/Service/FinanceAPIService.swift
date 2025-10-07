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
        
    }
}
