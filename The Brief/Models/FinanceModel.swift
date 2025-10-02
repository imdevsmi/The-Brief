//
//  FinanceModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import Foundation

struct FinanceRatesResponse: Codable {
    let rates: [String: FinanceRate]
}

struct FinanceRate: Codable {
    let bid: String
    let offer: String
}
