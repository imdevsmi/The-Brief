//
//  NetworkService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import Foundation

// MARK: - News API Protocol
protocol NewsAPIServiceProtocol {
    func searchNews(searchString: String, page: Int, pageSize: Int, from: Date?, completion: @escaping (Result<NewsModel, NetworkError>) -> Void)
    func fetchNews(country: String, page: Int, pageSize: Int, category: String?, from: Date?, completion: @escaping (Result<NewsModel, NetworkError>) -> Void)
}

// MARK: - News API Service
final class NewsAPIService: NewsAPIServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://newsapi.org/v2/"
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    // MARK: - Search News
    func searchNews(searchString: String, page: Int = 1, pageSize: Int = 20, from: Date? = nil, completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "everything")
        
        var queryItems = [
            URLQueryItem(name: "q", value: searchString),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "apiKey", value: SecureConfig.newsApiKey)]
        
        if let fromDate = from {
            let isoString = ISO8601DateFormatter().string(from: fromDate)
            queryItems.append(URLQueryItem(name: "from", value: isoString))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil, completion: completion)
    }
    
    // MARK: - Fetch News
    func fetchNews(country: String, page: Int = 1, pageSize: Int = 20, category: String? = nil, from: Date? = nil, completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "top-headlines")
        
        var queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "apiKey", value: SecureConfig.newsApiKey)]
        
        if let category = category { queryItems.append(URLQueryItem(name: "category", value: category)) }
        
        if let fromDate = from {
            let isoString = ISO8601DateFormatter().string(from: fromDate)
            queryItems.append(URLQueryItem(name: "from", value: isoString))
        }
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil, completion: completion)
    }
}
