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
    private var interstitialCounter = 0

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
        // load the interstitial if it doesnt exist
        if interstitial == nil {
            loadInterstitial()
        }

        // don't show the ad on the first two clicks
        if interstitialCounter < 3 {
            return
        }

        // from the 3. click onwards show the ad if ready
        if let interstitial = interstitial {
            interstitial.present(from: viewController)
        } else {
            // if the interstitial isn't ready on the 3rd click just reload it
            loadInterstitial()
        }
    }
}

// MARK: - FullScreenContentDelegate
extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        loadInterstitial()
    }
}
