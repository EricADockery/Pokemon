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
    
    @Published var allPokemon = [PokemonCharacter]()
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
            .compactMap { $0 } //remove the optional TopLevelPokemon here
            .flatMap { all in pokemonFetcher.allPokemon(for: all.results.map {$0.url})} //map the top level one so that we can get the real pokemon behind the data
            .replaceError(with: []) // replace the array of real pokemon with [] if we fail.
            .map { $0.sorted { $0.id < $1.id } } //sort them by id first (TODO: feature enhancement add a button to the Navigation bar to sort by different things)
            .assign(to: \.allPokemon, on: self)
            .store(in: &disposables)
    }
}
