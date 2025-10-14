//
//  InterstitialAd.swift
//  The Brief
//
//  Created by Sami Gündoğan on 14.10.2025.
//

import GoogleMobileAds
import UIKit

final class AdManager: NSObject {
    
    static let shared = AdManager()
    private var interstitial: InterstitialAd?
    private var interstitialCounter: Int {
        get { UserDefaults.standard.integer(forKey: "interstitialCounter") }
        set { UserDefaults.standard.set(newValue, forKey: "interstitialCounter") }
    }
    
    private override init() {
        super.init()
        loadInterstitial()
        print("AdManager initialized")
    }
    
    deinit {
        print("InterstitialAd deinitialized")
    }
    
    // MARK: - Interstitial yükle
    func loadInterstitial() {
        let request = Request()
        InterstitialAd.load(with: SecureConfig.AdConfig.interstitialID,
                            request: Request()) { [weak self] ad, error in
            if let error = error {
                print("Interstitial load failed: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    // MARK: - Gösterme mantığı
    func showInterstitialIfNeeded(from viewController: UIViewController) {
        interstitialCounter += 1
        if interstitialCounter % 3 == 0 {
            if let interstitial = interstitial {
                interstitial.present(from: viewController)
            } else {
                print("Interstitial hazır değil, yeniden yükleniyor")
                loadInterstitial()
            }
        } else {
            if interstitial == nil {
                loadInterstitial()
            }
        }
    }
}

// MARK: - FullScreenContentDelegate
extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        loadInterstitial()
    }
}
