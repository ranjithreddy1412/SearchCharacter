//
//  CharacterModel.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import Foundation

struct Character: Identifiable, Decodable {
    let id: Int
    let name: String
    let species: String
    let status: String
    let origin: Origin
    let type: String
    let image: String
    let created: String
    
    struct Origin: Decodable {
        let name: String
    }
}

struct CharacterResponse: Decodable {
    let results: [Character]
}

