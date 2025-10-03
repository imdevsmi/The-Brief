//
//  TwelveDataFinanceModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 3.10.2025.
//

import Foundation

struct TwelveDataQuoteResponse: Codable {
    let symbol: String
    let bid: String?
    let ask: String?
    let price: String?
}
