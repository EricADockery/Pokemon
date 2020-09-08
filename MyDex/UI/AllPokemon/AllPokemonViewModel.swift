//
//  AllPokemonViewModel.swift
//  MyDex
//
//  Created by Eric Dockery on 9/8/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import Foundation
import Combine

class AllPokemonViewModel: ObservableObject, Identifiable {
    
    @Published var allPokemon: AllPokemon?
    
    // disposables keep the network request alive
    private var disposables = Set<AnyCancellable>()
    
    private let pokemonFetcher: PokemonFetcher
    
    init(pokemonFetcher: PokemonFetcher) {
        self.pokemonFetcher = pokemonFetcher
        pokemonFetcher.fetchAllPokemon().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("Error: \(error.self)")
            case .finished:
                print("Successful completion")
            }
        }) { [weak self] allPokemon in
            self?.allPokemon = allPokemon
            }.store(in: &disposables)
    }
}
