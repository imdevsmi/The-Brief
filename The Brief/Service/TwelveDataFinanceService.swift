//
//  TwelveDataFinanceService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 3.10.2025.
//

import Foundation

final class TwelveDataFinanceService: FinanceAPIServiceProtocol{
    
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://api.twelvedata.com"
    private let apiKey = SecureConfig.twelveDataApiKey
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void) {
        
    }
}
