//
//  FavoritesServices.swift
//  News
//
//  Created by Sami Gündoğan on 28.07.2025.
//

import Foundation

protocol FavoritesServicesProtocol {
    func saveFavoriteArtice(_ article: Article, completion: @escaping (Result<Void, FavoritesError>) -> Void)
    func fetchFavorites(completion: @escaping(Result<[Article], FavoritesError>)->Void)
    func updateFavorites(articles: [Article])
    func createFavoriteArticleDatabase()
}

final class FavoriteService {
    let manager: FavoritesManagerProtocol
    
    init(manager: FavoritesManagerProtocol = FavoritesManager(key: .favoritesArticle)) {
        self.manager = manager
    }
}

extension FavoriteService: FavoritesServicesProtocol {
    func saveFavoriteArtice(_ article: Article, completion: @escaping (Result<Void, FavoritesError>) -> Void) {
        <#code#>
    }
    
    func fetchFavorites(completion: @escaping (Result<[Article], FavoritesError>) -> Void) {
        manager.fetchAll(completion: completion)
    }
    
    func updateFavorites(articles: [Article]) {
        manager.save(item: articles)
    }
    
    func createFavoriteArticleDatabase() {
        <#code#>
    }
}
