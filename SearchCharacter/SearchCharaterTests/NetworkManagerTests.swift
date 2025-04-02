//
//  NetworkManagerTests.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import XCTest
import Combine
@testable import SearchCharater

class NetworkManagerTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockError = nil
    }

    func testFetchCharactersSuccess() {
        let expectation = self.expectation(description: "Characters fetched")
        
        let jsonString = """
        {
            "results": [
                {
                    "id": 1,
                    "name": "Rick Sanchez",
                    "species": "Human",
                    "status": "Alive",
                    "origin": { "name": "Earth" },
                    "type": "",
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "created": "2017-11-30T11:28:06.461Z"
                }
            ]
        }
        """
        MockURLProtocol.mockResponseData = jsonString.data(using: .utf8)
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        
        let networkManager = NetworkManager(session: mockSession)

        networkManager.fetchCharacters(name: "rick")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed with error: \(error)")
                }
            }, receiveValue: { characters in
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Rick Sanchez")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchCharactersFailure() {
        let expectation = self.expectation(description: "Characters fetch failed")
        
        MockURLProtocol.mockError = URLError(.notConnectedToInternet)
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        
        let networkManager = NetworkManager(session: mockSession)

        networkManager.fetchCharacters(name: "rick")
            .sink(receiveCompletion: { completion in
                if case .failure(let error as URLError) = completion {
                    XCTAssertEqual(error.code, .notConnectedToInternet)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected a URLError")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
}

