//
//  NetworkError.swift
//  The Brief
//
//  Created by Sami Gündoğan on 26.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest, requestFailed, requestFailedWithStatusCode(Int), decodingError, noData, customError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid Request. Please check your endpoint or parameters."

        case .requestFailed:
            return "Request Failed. Please try again later."

        case .requestFailedWithStatusCode(let code):
            return "Request failed with status code: \(code)."

        case .decodingError:
            return "Failed to decode response data."

        case .noData:
            return "No data received from the server."

        case .customError(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}
