//
//  Endpoint.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Foundation

enum Endpoint {
    case fetchCharacters(
        url: String = "/api/character",
        name: String = String(),
        status: String = String(),
        species: String = String(),
        gender: String = String()
    )
    
    case fetchLocations(
        url: String = "/api/location",
        name: String = String(),
        dimension: String = String()
    )
    
    case fetchEpisodes(
        url: String = "/api/episode",
        name: String = String(),
        episode: String = String()
    )
    
    var request: Result<URLRequest, NetworkError> {
        guard let url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.addValues(for: self)
        
        return .success(request)
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseUrl
        components.port = Constants.port
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    private var path: String {
        switch self {
        case .fetchCharacters(let url, _, _, _, _):
            return url
        case .fetchLocations(let url, _, _):
            return url
        case .fetchEpisodes(let url, _, _):
            return url
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .fetchCharacters(_, let name, let status, let species, let gender):
            return [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "species", value: species),
                URLQueryItem(name: "gender", value: gender)
            ]
        case .fetchLocations(_, let name, let dimension):
            return [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "dimension", value: dimension),
            ]
        case .fetchEpisodes(_, let name, let episode):
            return [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "episode", value: episode)
            ]
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .fetchCharacters:
            return HTTP.Method.get.rawValue
        case .fetchLocations:
            return HTTP.Method.get.rawValue
        case .fetchEpisodes:
            return HTTP.Method.get.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .fetchCharacters:
            return nil
        case .fetchLocations:
            return nil
        case .fetchEpisodes:
            return nil
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .fetchCharacters, .fetchLocations, .fetchEpisodes:
            setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            setValue(Constants.API_KEY, forHTTPHeaderField: HTTP.Headers.Key.apiKey.rawValue)
        }
    }
}
