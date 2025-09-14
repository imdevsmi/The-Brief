//
//  NetworkManager.swift
//  The Brief
//
//  Created by Sami Gündoğan on 26.05.2025.
//

import Foundation

// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

// MARK: - Network Manager Protocol
protocol NetworkManagerProtocol {
    func request<T: Codable>(url: URL, method: HTTPMethod, headers: [String: String]?, completion: @escaping (Result<T, NetworkError>) -> Void)
}

// MARK: - Network Manager
final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Codable>(url: URL, method: HTTPMethod = .GET, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.customError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.requestFailedWithStatusCode(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
