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
    
    private let alamofireService: AlamofireService
    private let asyncService: AsyncService
    private let closureService: ClosureService
    private let combineService: CombineService
    
    // MARK: - Properties
    
    /// defines the way service will be called
    enum ServiceType {
        case alamofire
        case async
        case closure
        case combine
    }
    
    private let serviceType: ServiceType
    
    /// Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    /// callbacks
    var onFetchCharacters: (([Character]) -> Void)?
    var onFetchError: ((String) -> Void)?
    
    // MARK: - Initializer
    
    init(alamofireService: AlamofireService = AlamofireService(),
         asyncService: AsyncService = AsyncService(),
         closureService: ClosureService = ClosureService(),
         combineService: CombineService = CombineService(),
         serviceType: ServiceType) {
        
        self.alamofireService = alamofireService
        self.asyncService = asyncService
        self.closureService = closureService
        self.combineService = combineService
        self.serviceType = serviceType
    }
    
    // MARK: - Methods
    
    func fetchCharacters() {
        switch serviceType {
        case .alamofire:
            fetchCharactersWithAlamofire()
        case .async:
            fetchCharactersWithAsync()
        case .closure:
            fetchCharactersWithClosure()
        case .combine:
            fetchCharactersWithCombine()
        }
    }
    
    private func fetchCharactersWithAlamofire() {
        Task {
            do {
                let characters = try await alamofireService.fetchCharacters()
                onFetchCharacters?(characters)
            } catch let error {
                onFetchError?(error.localizedDescription)
            }
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
}
