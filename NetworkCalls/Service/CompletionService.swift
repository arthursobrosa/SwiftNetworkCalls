//
//  CompletionService.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Foundation

class CompletionService {
    private func performRequest<T: Decodable>(_ request: Result<URLRequest, NetworkError>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var urlRequest: URLRequest
        
        switch request {
        case .success(let request):
            urlRequest = request
        case .failure(let error):
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchCharacters(_ completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        let endPoint: Endpoint = .fetchCharacters()
        let request = endPoint.request
        
        performRequest(request) { [weak self] (result: Result<CharacterResponse, NetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let characterResponse):
                fetchImages(for: characterResponse.results, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchImages(for characters: [Character], completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        var charactersWithImage = characters
        
        let dispatchGroup = DispatchGroup()
        
        for (index, character) in characters.enumerated() {
            dispatchGroup.enter()
            
            fetchImageData(from: character.imagePath) { result in
                switch result {
                case .success(let imageData):
                    charactersWithImage[index].imageData = imageData
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(charactersWithImage))
        }
    }
    
    private func fetchImageData(from urlString: String, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        let url = URL(string: urlString)
        
        guard let url else {
            completion(.failure(.invalidImage(urlString: urlString)))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                
                completion(.failure(.invalidImage(urlString: urlString)))
                return
            }
            
            completion(.success(data))
            return
        }.resume()
    }
}
