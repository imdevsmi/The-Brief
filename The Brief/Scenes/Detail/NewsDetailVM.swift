//
//  NewsDetailVM.swift
//  The Brief
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import Foundation

protocol NewsDetailVMInputProtocol {
    func shareArticle()
}

final class NewsDetailVM {
    
    // MARK: Properties
    let article: Article
    
    // MARK: Inits
    init(article: Article) { self.article = article }
}
