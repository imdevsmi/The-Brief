//
//  CategoryModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 11.09.2025.
//

import Foundation

enum CategoryModel: String, Codable, CaseIterable {
    case general, business, entertainment, health, science, sports, technology
    
    var displayName: String {
        switch self {
        case .general:
            return "general"
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        }
    }
}
