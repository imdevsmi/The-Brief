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
        case .general: return L("category_general")
        case .business: return L("category_business")
        case .entertainment: return L("category_entertainment")
        case .health: return L("category_health")
        case .science: return L("category_science")
        case .sports: return L("category_sports")
        case .technology: return L("category_technology")
        }
    }
}
