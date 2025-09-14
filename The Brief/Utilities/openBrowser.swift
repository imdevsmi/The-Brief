//
//  OpenBrowser.swift
//  The Brief
//
//  Created by Sami Gündoğan on 10.06.2025.
//

import UIKit

final class openBrowser: UIActivity {
    
    // MARK: - Properties
    private var url: URL?
    
    // MARK: - Activity Info
    override var activityTitle: String? { "Open in Safari" }
    override var activityImage: UIImage? { UIImage(systemName: "safari") }
    override var activityType: UIActivity.ActivityType? { UIActivity.ActivityType("https://www.linkedin.com/in/samigundogan/") }
    
    // MARK: - Lifecycle
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool { activityItems.contains { $0 is URL } }
    override func prepare(withActivityItems activityItems: [Any]) { url = activityItems.first(where: { $0 is URL }) as? URL }
    override func perform() { if let url = url { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
        activityDidFinish(true)
    }
}
