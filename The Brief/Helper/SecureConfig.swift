//
//  Secrets.swift
//  The Brief
//
//  Created by Sami Gündoğan on 17.09.2025.
//

import Foundation

struct SecureConfig {
    // MARK: - Generic Plist Reader
    private static func readValue(from plist: String, key: String, fatalMessage: String) -> String {
        guard let path = Bundle.main.path(forResource: plist, ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict[key] as? String else { fatalError(fatalMessage) }
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Ad Unit IDs
    static var bannerAd: String { return readValue(from: "Info", key: "GADApplicationIdentifier", fatalMessage: "BannerAdUnitID not found in Info.plist") }
    static var interstitialAd: String { return readValue(from: "Info", key: "GADInterstitialAdUnitID", fatalMessage: "InterstitialAdUnitID not found in Info.plist") }
    
    // MARK: - API Keys
    static var newsApiKey: String { return readValue(from: "Secrets", key: "NewsAPIKey", fatalMessage: "NewsAPIKey not found in Secrets.plist") }
    static var weatherApiKey: String { return readValue(from: "Secrets", key: "WeatherAPIKey", fatalMessage: "WeatherAPIKey not found in Secrets.plist") }
    static var financeApiKey: String { return readValue(from: "Secrets", key: "FinanceAPIKey", fatalMessage: "FinanceAPIKey not found in Secrets.plist") }
}
