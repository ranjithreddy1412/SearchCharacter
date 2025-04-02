//
//  CharacterViewModel.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import Foundation
import Combine

class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let characterService: CharacterServiceProtocol

    // MARK: - Initializer with Dependency Injection
    init(characterService: CharacterServiceProtocol = NetworkManager.shared) {
        self.characterService = characterService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.fetchCharacters(name: text)
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch Method
    func fetchCharacters(name: String) {
        guard !name.isEmpty else {
            characters = []
            return
        }

        isLoading = true
        errorMessage = nil

        characterService.fetchCharacters(name: name)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.characters = []
                    }
                }
            }, receiveValue: { [weak self] characters in
                DispatchQueue.main.async {
                    self?.characters = characters
                }
            })
            .store(in: &cancellables)
    }
}
