//
//  CharacterViewModelTests.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//


import XCTest
import Combine
@testable import SearchCharater

class CharacterViewModelTests: XCTestCase {
    var viewModel: CharacterViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = CharacterViewModel()
        cancellables = []
    }
    
    func testCharacterFetching() {
        let mockService = MockCharacterService()
        let viewModel = CharacterViewModel(characterService: mockService)

        let expectation = self.expectation(description: "Mock Fetching")

        viewModel.$characters
            .dropFirst()
            .sink { characters in
                XCTAssertFalse(characters.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchCharacters(name: "rick")

        wait(for: [expectation], timeout: 2.0)
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
}


