//
//  CharacterDetailView.swift
//  SearchCharater
//
//  Created by ranjith kumar reddy b perkampally on 4/1/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            } placeholder: {
                ProgressView()
            }
            .background(Color.gray.opacity(0.2))
            
            Text(character.name)
                .font(.largeTitle)
                .bold()
            
            Text("Species: \(character.species)")
            Text("Status: \(character.status)")
            Text("Origin: \(character.origin.name)")
            
            if !character.type.isEmpty {
                Text("Type: \(character.type)")
            }
            
            Text("Created: \(formattedDate(from: character.created))")
            
            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
    }

    private func formattedDate(from isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            return outputFormatter.string(from: date)
        }
        return isoDate
    }
}
