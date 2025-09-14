//
//  HomeVM.swift
//  The Brief
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import Foundation
import Kingfisher

enum Mode: Equatable {
    case top(category: String)
    case search(String)
}

protocol HomeVMInputProtocol: AnyObject {
    func search(term: String)
    func viewDidLoad()
    func more()
    func changeCategory(to category: CategoryModel)
}

final class HomeVM {
    
    // MARK: Properties
    
    private let newsService: NetworkServiceProtocol
    private(set) var articles: [Article] = []
    private let pageSize = 20
    
    private var page = 1
    private var mode: Mode = .top(category: "general")
    private var selectedCategory: String = "general"
    private var isLoading = false
    
    private let debounceInterval: TimeInterval = 0.5
    private var debounceWorkItem: DispatchWorkItem?
    
    weak var input: HomeVMInputProtocol?
    weak var output: HomeVMOutputProtocol?
    
    // MARK: Init
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        newsService = service
        input = self
    }
    
    deinit { debounceWorkItem?.cancel() }
}

// MARK: - HomeVMInputProtocol

extension HomeVM: HomeVMInputProtocol {
    
    func search(term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.mode = trimmed.isEmpty ? .top(category: self.selectedCategory) : .search(trimmed)
            self.fetch(reset: true)
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    func viewDidLoad() {
        fetch(reset: true)
    }
    
    func more() {
        if case .top(_) = mode, page > 2 { return }
        guard isLoading else { return }
        fetch(reset: false)
    }
    
    func changeCategory(to category: CategoryModel) {
        selectedCategory = category.rawValue
        mode = .top(category: selectedCategory)
        fetch(reset: true)
    }
}

private extension HomeVM {
    
    func fetch(reset: Bool) {
        guard !isLoading else { return }
        isLoading = true
        if reset { page = 1 }
        
        let completion: (Result<NewsModel, NetworkError>) -> Void = { [weak self] result in
            guard let self else { return }
            isLoading = false
            
            switch result {
            case .success(let newsModel):
                if reset { articles = newsModel.articles } else { articles += newsModel.articles }
                output?.didUpdateArticles(articles, append: !reset)
                output?.didBecomeEmpty(articles.isEmpty)
                
                if !newsModel.articles.isEmpty { page += 1 }
            case .failure(let error):
                output?.didFail(with: error)
            }
        }
        switch mode {
        case .top(let category):
            newsService.fetchNews(country: "us", page: page, pageSize: pageSize, category: category, completion: completion)
            
        case .search(let query):
            newsService.searchNews(searchString: query, page: page, pageSize: pageSize, completion: completion)
        }
    }
}
