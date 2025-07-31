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
    
}

extension FavoriteService: FavoritesServicesProtocol {
    func saveFavoriteArtice(_ article: Article, completion: @escaping (Result<Void, FavoritesError>) -> Void) {
        <#code#>
    }
    
    func fetchFavorites(completion: @escaping (Result<[Article], FavoritesError>) -> Void) {
        <#code#>
    }
    
    func updateFavorites(articles: [Article]) {
        <#code#>
    }
    
    func createFavoriteArticleDatabase() {
        <#code#>
    }
}
