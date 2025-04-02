//
//  NetworkManager.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import Foundation
import Combine

protocol CharacterServiceProtocol {
    func fetchCharacters(name: String) -> AnyPublisher<[Character], Error>
}

class NetworkManager:CharacterServiceProtocol {
    static let shared = NetworkManager()
    
    private let baseURL = "https://rickandmortyapi.com/api/character/?name="
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchCharacters(name: String) -> AnyPublisher<[Character], Error> {
        guard let url = URL(string: "\(baseURL)\(name)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CharacterResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}



