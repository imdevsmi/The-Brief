//
//  FavoritesManager.swift
//  The Brief
//
//  Created by Sami Gündoğan on 30.07.2025.
//

import Foundation

protocol FavoritesManagerProtocol {
    func save<T: Codable>(item: T)
    func fetchAll<T: Codable>(completion: @escaping(Result<T, FavoritesError>) -> Void)
    func removeAll()
}

final class FavoritesManager {
    private let userDefaults = UserDefaults.standard
    private let key: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(key: FavoritesKey, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.key = key.rawValue
        self.decoder = decoder
        self.encoder = encoder
    }
}

extension FavoritesManager: FavoritesManagerProtocol {
    func save<T: Codable>(item: T) {
        if let data = try? encoder.encode(item) {
            userDefaults.set(data, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    func fetchAll<T: Codable>(completion: @escaping (Result<T, FavoritesError>) -> Void) {
        if let data = userDefaults.data(forKey: key) {
            do {
                let item = try decoder.decode(T.self, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(.error))
            }
        } else {
            if T.self == [Article].self {
                completion(.success([] as! T))
            } else {
                completion(.failure(.error))
            }
        }
    }
    
    func removeAll() { userDefaults.removeObject(forKey: key) }
}
