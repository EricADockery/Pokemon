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
    
    init(pokemonFetcher: PokemonFetcher, topLevelPokemon: TopLevelPokemon) {
        self.pokemonFetcher = pokemonFetcher
        updateView(for: topLevelPokemon.url)
        
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] notification in
                print(notification.name)
                self?.handleBackgroundEvent()
            }
            .store(in: &disposables)
    }
    
    func updateView(for location: String) {
        pokemonFetcher.pokemon(for: location)
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: \.pokemonCharacter, on: self)
            .store(in: &disposables) //This has to be in every Publisher and keeps the request alive until the request finishes some way.
    }
    
    func handleBackgroundEvent() {
        view?.dismissOnBackground()
    }
}
