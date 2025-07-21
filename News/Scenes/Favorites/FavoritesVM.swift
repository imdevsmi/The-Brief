//
//  FavoritesVM.swift
//  News
//
//  Created by Sami Gündoğan on 19.07.2025.
//

import Foundation

protocol FavoritesVMOutputProtocol: AnyObject{
    
}

final class FavoritesVM {
    
    weak var output: FavoritesVMOutputProtocol?
    weak var input: FavoritesVCInputProtocol?
    
    private(set) var favoritesArticles: [Article] = []
    
}
