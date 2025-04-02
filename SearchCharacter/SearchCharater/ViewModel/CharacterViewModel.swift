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
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.fetchCharacters(name: text)
            }
            .store(in: &cancellables)
    }

    func fetchCharacters(name: String) {
        guard !name.isEmpty else {
            characters = []
            return
        }
        
        isLoading = true
        
        NetworkManager.shared.fetchCharacters(name: name)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] characters in
                self?.characters = characters
            })
            .store(in: &cancellables)
    }
}

