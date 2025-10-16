//
//  InterstitialAd.swift
//  The Brief
//
//  Created by Sami Gündoğan on 14.10.2025.
//

import GoogleMobileAds
import UIKit

final class AdManager: NSObject {
    
    // MARK: - Properties
    static let shared = AdManager()
    private var interstitial: InterstitialAd?
    private var interstitialCounter = 0

    private override init() {
        super.init()
        loadInterstitial()
    }
    
    deinit { print("InterstitialAd deinitialized") }
    
    // MARK: - Load Interstitial
    func loadInterstitial() {
        _ = Request()
        InterstitialAd.load(with: SecureConfig.AdConfig.interstitialID, request: Request()) { [weak self] ad, error in
            if error != nil { return }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    // MARK: - Display Logic
    func showInterstitialIfNeeded(from viewController: UIViewController) {
        interstitialCounter += 1
        if interstitial == nil { loadInterstitial() }
        
        switch interstitialCounter {
        case 1, 2:
            break
        default:
            if let interstitial = interstitial {
                interstitial.present(from: viewController)
            } else {
                loadInterstitial()
            }
        }
    }
}

// MARK: - FullScreenContentDelegate
extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) { loadInterstitial() }
}
