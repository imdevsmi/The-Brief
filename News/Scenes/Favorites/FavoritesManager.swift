//
//  FavoritesManager.swift
//  News
//
//  Created by Sami Gündoğan on 30.07.2025.
//

import Foundation

enum FavoritesError: Error {
    case error
}

enum FavoritesKey: String {
    case favoritesArticle = "favoritesArticle"
    case theme = "theme"
}

protocol FavoritesManagerProtocol {
    func save<T: Codable>(item: T)
    func fetchAll<T: Codable>(completion: @escaping(Result<T, FavoritesError>) -> Void)
    func removeAll()
}

final class FavoritesManager {
    private let userDefaults = UserDefaults.standard
    private let key: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(key: FavoritesKey, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.key = key.rawValue
        self.decoder = decoder
        self.encoder = encoder
    }
}
