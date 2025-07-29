//
//  FavoritesVM.swift
//  News
//
//  Created by Sami Gündoğan on 19.07.2025.
//

import Foundation

protocol FavoritesVMOutputProtocol: AnyObject{
    func viewDidLoad()
    func fetchFavoritesNews()
    func removeNews(at index: Int)
}

final class FavoritesVM {
    
    weak var output: FavoritesVMOutputProtocol?
    weak var input: FavoritesVCInputProtocol?
    
    private(set) var favoritesArticles: [Article] = []
    
}

extension FavoritesVM: FavoritesVMOutputProtocol {
    func viewDidLoad() {
        
    }
    
    func fetchFavoritesNews() {
    }
    
    func removeNews(at index: Int) {
        
    }
}
