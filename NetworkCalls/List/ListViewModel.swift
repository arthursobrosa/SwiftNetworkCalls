//
//  ListViewModel.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import Combine
import Foundation

class ListViewModel {
    // MARK: - Service to get model
    
    private let completionService: CompletionService
    private let combineService: CombineService
    private let asyncService: AsyncService
    
    // MARK: - Properties
    
    /// defines the way service will be called
    enum ServiceType {
        case async
        case combine
        case completion
    }
    
    private let serviceType: ServiceType
    
    /// Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    /// callbacks
    var onFetchCharacters: (([Character]) -> Void)?
    var onFetchError: ((String) -> Void)?
    
    // MARK: - Initializer
    
    init(completionService: CompletionService = CompletionService(),
         combineService: CombineService = CombineService(),
         asyncService: AsyncService = AsyncService(),
         serviceType: ServiceType) {
        
        self.completionService = completionService
        self.combineService = combineService
        self.asyncService = asyncService
        self.serviceType = serviceType
    }
    
    // MARK: - Methods
    
    func fetchCharacters() {
        switch serviceType {
        case .async:
            fetchCharactersWithAsync()
        case .combine:
            fetchCharactersWithCombine()
        case .completion:
            fetchCharactersWithCompletion()
        }
    }
    
    private func fetchCharactersWithAsync() {
        Task {
            do {
                let characters = try await asyncService.fetchCharacters()
                onFetchCharacters?(characters)
            } catch let error {
                onFetchError?(error.localizedDescription)
            }
        }
    }
    
    private func fetchCharactersWithCombine() {
        combineService.fetchCharacters()
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    print("Finished fetching characters")
                case .failure(let error):
                    onFetchError?(error.localizedDescription)
                }
            } receiveValue: { [weak self] characters in
                guard let self else { return }
                
                onFetchCharacters?(characters)
            }
            .store(in: &cancellables)
    }
    
    private func fetchCharactersWithCompletion() {
        completionService.fetchCharacters { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let characters):
                onFetchCharacters?(characters)
            case .failure(let error):
                onFetchError?(error.localizedDescription)
            }
        }
    }
}
