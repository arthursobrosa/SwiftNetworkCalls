//
//  NetworkError.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(_ error: Error?)
    case invalidResponse
    case invalidStatusCode(_ statusCode: Int)
    case invalidData
    case decodingError
    case invalidImage(urlString: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            NSLocalizedString("URL provided is invalid", comment: "Invalid URL")
        case .requestFailed(let error):
            NSLocalizedString("Request failed with error \(error?.localizedDescription ?? "")", comment: "Request Failed")
        case .invalidResponse:
            NSLocalizedString("Response is not a HTTPURLResponse", comment: "Invalid Response")
        case .invalidStatusCode(let statusCode):
            NSLocalizedString("Response status code \(statusCode)", comment: "Invalid Response")
        case .invalidData:
            NSLocalizedString("Invalid data returned from server", comment: "Invalid data")
        case .decodingError:
            NSLocalizedString("Could not decode data from server", comment: "Decoding error")
        case .invalidImage(let urlString):
            NSLocalizedString("Failed to fecth image data from url \(urlString)", comment: "Invalid image")
        }
    }
}
