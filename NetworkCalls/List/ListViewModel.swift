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
    
    private let asyncService: AsyncService
    private let combineService: CombineService
    private let closureService: ClosureService
    
    // MARK: - Properties
    
    /// defines the way service will be called
    enum ServiceType {
        case async
        case combine
        case closure
    }
    
    private let serviceType: ServiceType
    
    /// Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    /// callbacks
    var onFetchCharacters: (([Character]) -> Void)?
    var onFetchError: ((String) -> Void)?
    
    // MARK: - Initializer
    
    init(asyncService: AsyncService = AsyncService(),
         combineService: CombineService = CombineService(),
         closureService: ClosureService = ClosureService(),
         serviceType: ServiceType) {
        
        self.asyncService = asyncService
        self.combineService = combineService
        self.closureService = closureService
        self.serviceType = serviceType
    }
    
    // MARK: - Methods
    
    func fetchCharacters() {
        switch serviceType {
        case .async:
            fetchCharactersWithAsync()
        case .combine:
            fetchCharactersWithCombine()
        case .closure:
            fetchCharactersWithClosure()
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
    
    private func fetchCharactersWithClosure() {
        closureService.fetchCharacters { [weak self] result in
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
