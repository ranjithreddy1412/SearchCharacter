//
//  NetworkManager.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://rickandmortyapi.com/api/character/?name="
    
    func fetchCharacters(name: String) -> AnyPublisher<[Character], Error> {
        guard let url = URL(string: "\(baseURL)\(name)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CharacterResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


