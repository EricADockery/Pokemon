//
//  PokemonViewModel.swift
//  MyDex
//
//  Created by Eric Dockery on 3/22/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import Combine
import Foundation
import UIKit

protocol PokemonDetailViewConformance: class {
    func dismissOnBackground()
}

class PokemonViewModel: ObservableObject, Identifiable {
    //The properly delegate @Published modifier makes it possible to observe
    @Published var pokemonCharacter: PokemonCharacter?
    // disposables keep the network request alive
    private var disposables = Set<AnyCancellable>()
    
    private let pokemonFetcher: PokemonFetcher
    weak var view: PokemonDetailViewConformance?
    
    init(pokemonFetcher: PokemonFetcher, character: PokemonCharacter) {
        self.pokemonFetcher = pokemonFetcher
        pokemonCharacter = character
    }
}
