//
//  Secrets.swift
//  The Brief
//
//  Created by Sami Gündoğan on 17.09.2025.
//

import Foundation

struct SecureConfig {
    static var bannerAd: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["GADApplicationIdentifier"] as? String else {
            fatalError("BannerAdUnitID not found in Info.plist")
        }
        return value
    }
    
    struct InterstitialAd {
        static var interstitialID: String {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path),
                  let value = dict["GADInterstitialAdUnitID"] as? String else {
                fatalError("InterstitialAdUnitID not found in Info.plist")
            }
            return value
        }
    }

    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["NewsAPIKey"] as? String else {
            fatalError("NewsAPIKey not found in Secrets.plist")
        }
        return key.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static var weatherApiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["WeatherAPIKey"] as? String else {
            fatalError("WeatherAPIKey not found in Secrets.plist")
        }
        return key.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static var financeApiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["FinanceAPIKey"] as? String else {
            fatalError("FinanceAPIKey not found in Secrets.plist")
        }
        return key.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
