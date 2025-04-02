//
//  MockCharacterService.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import Foundation
import Combine

class MockCharacterService: CharacterServiceProtocol {
    func fetchCharacters(name: String) -> AnyPublisher<[Character], Error> {
        let mockCharacter = Character(
            id: 1,
            name: "Rick Sanchez",
            species: "Human",
            status: "Alive",
            origin: .init(name: "Earth"),
            type: "",
            image: "",
            created: "2017-11-30T11:28:06.461Z"
        )
        return Just([mockCharacter])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


