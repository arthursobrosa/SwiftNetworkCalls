//
//  HTTP.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Foundation

enum HTTP {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Headers {
        enum Key: String {
            case contentType = "Content-Type" /// only for PUT/POST methods
            case apiKey = "API_KEY" /// if you need one
        }
        
        enum Value: String {
            case applicationJson = "application/json" /// only for PUT/POST methods
        }
    }
}
