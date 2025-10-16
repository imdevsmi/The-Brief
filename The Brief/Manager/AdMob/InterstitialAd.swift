//
//  InterstitialAd.swift
//  The Brief
//
//  Created by Sami Gündoğan on 14.10.2025.
//

import GoogleMobileAds
import UIKit

final class InterstitialAds: NSObject {
    
    // MARK: - Properties
    static let shared = InterstitialAds()
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
        InterstitialAd.load(with: SecureConfig.interstitialAd, request: Request()) { [weak self] ad, error in
            if let error = error { return }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    // MARK: - Display Logic
    func showInterstitialIfNeeded(from vc: UIViewController) {
        interstitialCounter += 1
        if interstitial == nil { loadInterstitial() }
        
        switch interstitialCounter {
        case 1, 2:
            break
        default:
            if let interstitial = interstitial {
                interstitial.present(from: vc)
            } else {
                loadInterstitial()
            }
        }
    }
}

// MARK: - FullScreenContentDelegate
extension InterstitialAds: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) { loadInterstitial() }
}
