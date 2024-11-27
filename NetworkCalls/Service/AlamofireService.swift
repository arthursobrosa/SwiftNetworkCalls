//
//  AlamofireService.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 27/11/24.
//

import Alamofire
import Foundation

class AlamofireService {
    private func performRequest<T: Decodable>(_ request: Result<URLRequest, NetworkError>) async throws -> T {
        let urlRequest = try request.get()
        
        let response = try await AF.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .value
        
        return response
    }
    
    func fetchCharacters() async throws -> [Character] {
        let endPoint: Endpoint = .fetchCharacters()
        let request = endPoint.request
        
        let characterResponse: CharacterResponse = try await performRequest(request)
        return await fetchImages(for: characterResponse.results)
    }
    
    private func fetchImages(for characters: [Character]) async -> [Character] {
        var charactersWithImage = characters
        
        await withTaskGroup(of: Void.self) { group in
            for (index, character) in characters.enumerated() {
                group.addTask {
                    do {
                        charactersWithImage[index].imageData = try await self.fetchImageData(from: character.imagePath)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        return charactersWithImage
    }
    
    private func fetchImageData(from urlString: String) async throws -> Data? {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidImage(urlString: urlString)
        }
        
        let response = try await AF.request(url)
            .validate(statusCode: 200..<300)
            .serializingData()
            .value
        
        return response
    }
}
