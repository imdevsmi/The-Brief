//
//  FavoritesVM.swift
//  The Brief
//
//  Created by Sami Gündoğan on 19.07.2025.
//

import Foundation

protocol FavoritesVMInputProtocol: AnyObject{
    func viewDidLoad()
    func fetchFavoritesNews()
    func removeNews(at index: Int)
}

final class FavoritesVM {
    
    // MARK: - Properties
    weak var input: FavoritesVMInputProtocol?
    weak var output: FavoritesVCOutputProtocol?
    
    private(set) var favoritesArticles: [Article] = []
    private let service: FavoritesServicesProtocol
    
    // MARK: - Init
    init(service: FavoritesServicesProtocol = FavoriteService()) {
        self.service = service
        input = self
    }
}

// MARK: - Lifecycle
extension FavoritesVM: FavoritesVMInputProtocol {
    func viewDidLoad() {
        fetchFavoritesNews()
    }
    
    func fetchFavoritesNews() {
        service.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                self.favoritesArticles = articles
                self.output?.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func removeNews(at index: Int) {
        favoritesArticles.remove(at: index)
        service.updateFavorites(articles: favoritesArticles)
        output?.reloadData()
    }
}
