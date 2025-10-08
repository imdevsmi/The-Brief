//
//  FinanceUIModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import Foundation

struct FinanceUIModel {
    let pair: String
    let bid: String
    let offer: String
}

extension FinanceUIModel {
    static func fromResponse(_ response: FinanceRatesResponse, for pairs: [String]) -> [FinanceUIModel] {
        var models: [FinanceUIModel] = []
        
        for pair in pairs {
            let components = pair.split(separator: "/").map(String.init)
            guard components.count == 2 else { continue }
            
            let baseCurrency = components[0]
            let quoteCurrency = components[1]
            guard let baseRate = response.rates[baseCurrency], let quoteRate = response.rates[quoteCurrency] else { continue }
            
            let rate = quoteRate / baseRate
            let formatted = String(format: "%.4f", rate)
            
            models.append(FinanceUIModel(pair: pair, bid: formatted, offer: formatted))
        }
        return models
    }
}
