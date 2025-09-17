//
//  BannerAd.swift
//  The Brief
//
//  Created by Sami Gündoğan on 17.09.2025.
//

import GoogleMobileAds
import SnapKit
import UIKit

final class BannerAdView: UIView {
    
    // MARK: - Properties
    private lazy var bannerView: BannerView = {
        let viewWidth = UIScreen.main.bounds.width
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: viewWidth)
        let banner = BannerView(frame: .zero)
        
        banner.adUnitID = Info.bannerID
        banner.adSize = adSize
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
        
        return banner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBanner()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Setup Methods
    private func setupBanner() {
        addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(bannerView.adSize.size.height)
        }
        bannerView.load(Request())
    }
    
    // MARK: - Public Methods
    func reloadAd() {
        bannerView.load(Request())
    }
}
