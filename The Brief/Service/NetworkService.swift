//
//  NetworkService.swift
//  The Brief
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import Foundation

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func searchNews(searchString: String, page: Int, pageSize: Int, completion: @escaping (Result<NewsModel, NetworkError>) -> Void)
    func fetchNews(country: String, page: Int, pageSize: Int, category: String?, completion: @escaping (Result<NewsModel, NetworkError>) -> Void)
}

// MARK: - Network Service
final class NetworkService: NetworkServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://newsapi.org/v2/"
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["NewsAPIKey"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return key
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) { self.networkManager = networkManager }
    
    // MARK: - Search News
    func searchNews(searchString: String, page: Int = 1, pageSize: Int = 20, completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: baseURL + "everything")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: searchString),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "apiKey", value: apiKey)]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil, completion: completion)
    }
    
    // MARK: - Fetch News
    func fetchNews(country: String, page: Int = 1, pageSize: Int = 20, category: String? = nil, completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        
        var urlComponents = URLComponents(string: baseURL + "top-headlines")
        var queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        if let category = category { queryItems.append(URLQueryItem(name: "category", value: category)) }

        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        networkManager.request(url: url, method: .GET, headers: nil, completion: completion)
    }
}
