//
//  HomeVM.swift
//  News
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import Foundation
import Kingfisher

enum Mode: Equatable {
    case top
    case search(String)
}

protocol HomeVMInputProtocol: AnyObject {
    func search(term: String)
    func viewDidLoad()
    func loadMore()
}

final class HomeVM {
    
    // MARK: Properties
    
    private let newsService: NetworkServiceProtocol
    private(set) var articles: [Article] = []
    private let pageSize = 20
    
    private var page = 1
    private var mode: Mode = .top
    private var isLoading = false
    
    private let debounceInterval: TimeInterval = 0.5
    private var debounceWorkItem: DispatchWorkItem?
    
    weak var inputDelegate: HomeVMInputProtocol?
    weak var outputDelegate: HomeVMOutputProtocol?
    
    // MARK: Init

    init(service: NetworkServiceProtocol = NetworkService()) {
        newsService = service
        inputDelegate = self
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
            self.mode = trimmed.isEmpty ? .top : .search(trimmed)
            self.fetch(reset: true)
        }

        debounceWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    func viewDidLoad() {
        fetch(reset: true)
    }

    func loadMore() {
        if mode == .top, page > 2 { return }
        guard !isLoading else { return }
        fetch(reset: false)
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
                outputDelegate?.didUpdateArticles(articles, append: !reset)
                outputDelegate?.didBecomeEmpty(articles.isEmpty)
                
                if !newsModel.articles.isEmpty { page += 1 }
                print("page: \(page)")
                print("articles count: \(articles.count)")

            case .failure(let error):
                outputDelegate?.didFail(with: error)
            }
        }

        switch mode {
        case .top:
            newsService.fetchNews(country: "us", page: page, pageSize: 20, completion: completion)
        case .search(let query):
            newsService.searchNews(searchString: query, page: page, pageSize: 20, completion: completion)
        }
    }
}
