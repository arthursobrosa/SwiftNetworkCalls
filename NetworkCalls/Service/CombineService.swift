//
//  CombineService.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Combine
import Foundation

class CombineService {
    private func performRequest<T: Decodable>(_ request: Result<URLRequest, NetworkError>) -> AnyPublisher<T, NetworkError> {
        switch request {
        case .success(let urlRequest):
            
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { data, response -> T in
                    guard let response = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    
                    guard response.statusCode == 200 else {
                        throw NetworkError.invalidStatusCode(response.statusCode)
                    }
                    
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                }
                .mapError { error in
                    (error as? NetworkError) ?? NetworkError.decodingError
                }
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func fetchCharacters() -> AnyPublisher<[Character], NetworkError> {
        let endPoint: Endpoint = .fetchCharacters()
        let request = endPoint.request
        
        return performRequest(request)
            .flatMap { (characterResponse: CharacterResponse) -> AnyPublisher<[Character], Never> in
                self.fetchImages(for: characterResponse.results)
            }
            .mapError { _ in
                NetworkError.decodingError
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchImages(for characters: [Character]) -> AnyPublisher<[Character], Never> {
        let publishers = characters.enumerated().map { index, character in
            fetchImageData(from: character.imagePath)
                .replaceError(with: nil)
                .map { data -> Character in
                    var characterWithImage = character
                    characterWithImage.imageData = data
                    return characterWithImage
                }
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    private func fetchImageData(from urlString: String) -> AnyPublisher<Data?, NetworkError> {
        let url = URL(string: urlString)
        
        guard let url else {
            return Fail(error: NetworkError.invalidImage(urlString: urlString)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data? in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    
                    throw NetworkError.invalidImage(urlString: urlString)
                }
                
                return data
            }
            .mapError { error in
                (error as? NetworkError) ?? NetworkError.invalidImage(urlString: urlString)
            }
            .eraseToAnyPublisher()
    }
}
