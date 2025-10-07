//
//  FinanceModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import Foundation

struct FinanceRatesResponse: Codable {
    let success: Bool
    let base: String
    let date: String
    let rates: [String: Double]
}
