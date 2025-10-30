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
    let timestamp: TimeInterval?
    let rates: [String: Double]
    let unit: String?
    
    var date: Date? {
        guard let timestamp else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }
}

enum FinanceSegment {
    case currencies
    case metals
}

