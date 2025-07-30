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
    weak var output: FavoritesVCOtputProtocol?
    
    private(set) var favoritesArticles: [Article] = []
    
}

extension FavoritesVM: FavoritesVMInputProtocol {
    func viewDidLoad() {
        
    }
    
    func fetchFavoritesNews() {
    }
    
    func removeNews(at index: Int) {
        
    }
}
