//
//  PokemonViewModel.swift
//  MyDex
//
//  Created by Eric Dockery on 3/22/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import Combine

class PokemonViewModel: ObservableObject, Identifiable {
    //The properly delegate @Published modifier makes it possible to observe
    @Published var pokemonCharacter: PokemonCharacter?
    
    // disposables keep the network request alive
    private var disposables = Set<AnyCancellable>()
    
    private let pokemonFetcher: PokemonFetcher
    
    init(pokemonFetcher: PokemonFetcher, topLevelPokemon: TopLevelPokemon) {
        self.pokemonFetcher = pokemonFetcher
        updateView(for: topLevelPokemon.url)
    }
    
    func updateView(for location: String) {
        pokemonFetcher.pokemon(for: location).sink(receiveCompletion: { error in
                switch error {
                case .failure(let error):
                    print("Error: \(error.self)")
                case .finished:
                    print("Successful completion")
                }
            }) { [weak self] pokemon in
                self?.pokemonCharacter = pokemon
        }
        .store(in: &disposables) //This has to be in every Publisher and keeps the request alive until the request finishes some way.
    }
}
