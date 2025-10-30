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

        let usdTryRate = response.rates["TRY"] ?? 1.0

        for pair in pairs {
            let components = pair.split(separator: "/").map(String.init)
            guard components.count == 2 else { continue }

            let base = components[0]
            let quote = components[1]

            guard let baseRate = response.rates[base],
                  let quoteRate = response.rates[quote] else { continue }

            var rate: Double
            var displayPair = pair

            switch (response.base, base, quote) {
            case (let baseCurrency, let b, _) where baseCurrency == b:
                rate = quoteRate
            case (let baseCurrency, _, let q) where baseCurrency == q:
                rate = 1 / baseRate
            default:
                rate = quoteRate / baseRate
            }

            if base.starts(with: "X") && quote == "USD" {
                rate *= usdTryRate
                displayPair = "\(base)/TRY"
            }
            
            let formatted = String(format: "%.3f", rate)
            models.append(FinanceUIModel(pair: displayPair, bid: formatted, offer: formatted))
        }
        return models
    }
}
