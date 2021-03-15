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
        
        //This can be reduced by doing .compactMap {} and
        // .replaceErrorWith {}
        pokemonFetcher.fetchAllPokemon()
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: \.allPokemon, on: self)
            .store(in: &disposables)
    }
}
