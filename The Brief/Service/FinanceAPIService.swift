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
    func fetchRates(pairs: [String], completion: @escaping (Result<[FinanceUIModel], NetworkError>) -> Void) {
        <#code#>
    }
}
