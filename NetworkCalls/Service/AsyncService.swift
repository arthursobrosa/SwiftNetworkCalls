//
//  AsyncService.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Foundation

class AsyncService {
    private func performRequest<T: Decodable>(_ request: Result<URLRequest, NetworkError>) async throws -> T {
        var urlRequest: URLRequest
        
        switch request {
        case .success(let request):
            urlRequest = request
        case .failure(let error):
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard response.statusCode == 200 else {
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError.decodingError
        }
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
                print("added task \(index)")
                group.addTask {
                    print("performing taks \(index)")
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
        let url = URL(string: urlString)
        
        guard let url else {
            throw NetworkError.invalidImage(urlString: urlString)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            
            throw NetworkError.invalidImage(urlString: urlString)
        }
        
        return data
    }
}
