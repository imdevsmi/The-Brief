//
//  FavoritesVM.swift
//  News
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
    
    weak var input: FavoritesVMInputProtocol?
    weak var output: FavoritesVCOutputProtocol?
    
    private(set) var favoritesArticles: [Article] = []
    private let service: FavoritesServicesProtocol
    
    init(service: FavoritesServicesProtocol = FavoriteService()) {
        self.service = service
        input = self
    }
}

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
        
    }
}
