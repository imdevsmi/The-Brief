//
//  NewsDetailVM.swift
//  News
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import Foundation

protocol NewsDetailVMInputProtocol {
    
}

final class NewsDetailVM {

    // MARK: Properties
    
    var article: Article

    // MARK: Inits

    init(article: Article) {
        self.article = article
    }
}

private extension NewsDetailVM {
    
}

extension NewsDetailVM: NewsDetailVMInputProtocol {
    
}
