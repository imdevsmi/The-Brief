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
    static func fromResponse(_ response: FinanceRatesResponse) -> [FinanceUIModel] {
        response.rates.map { pair, rate in
            FinanceUIModel(pair: pair, bid: rate.bid, offer: rate.offer)
        }
    }
}
