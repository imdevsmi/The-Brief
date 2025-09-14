//
//  FavoritesServices.swift
//  The Brief
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

// MARK: - FavoritesServicesProtocol Conformance
extension FavoriteService: FavoritesServicesProtocol {
    func saveFavoriteArtice(_ article: Article, completion: @escaping (Result<Void, FavoritesError>) -> Void) {
        manager.fetchAll { [weak self] (result: Result<[Article], FavoritesError>) in
            guard let self else { return }
            
            switch result {
            case .success(var articles):
                if (articles.firstIndex(where: { $0.url == article.url }) != nil) {
                    return
                }
                articles.append(article)
                self.manager.save(item: articles)
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func fetchFavorites(completion: @escaping (Result<[Article], FavoritesError>) -> Void) {
        manager.fetchAll(completion: completion)
    }
    
    func updateFavorites(articles: [Article]) {
        manager.save(item: articles)
    }
    
    func createFavoriteArticleDatabase() {
        manager.fetchAll { [weak self] (result: Result<[Article], FavoritesError>) in
            guard let self else { return }
            
            switch result {
            case .success(_):
                return
            case .failure(_):
                let articles: [Article] = []
                manager.save(item: articles)
            }
        }
    }
}
