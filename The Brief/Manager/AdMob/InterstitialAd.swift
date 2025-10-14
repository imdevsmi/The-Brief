//
//  InterstitialAd.swift
//  The Brief
//
//  Created by Sami Gündoğan on 14.10.2025.
//

import GoogleMobileAds
import UIKit

final class InterstitialAd: NSObject {
    
    static let shared = InterstitialAd()
    private var interstitial: InterstitialAd?
    private static let adCounterKey = "NewsDetailAdCounter"
    
    private override init() {
        super.init()
    }
}
