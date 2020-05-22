//
//  ViewController.swift
//  MyDex
//
//  Created by Eric Dockery on 3/21/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import UIKit
import Combine // this is needed for the subscribers in the view controller

final class PokemonViewController: UIViewController {
        
    private var pokemonViewModel: PokemonViewModel?
    
    //subscribes to the data change on the publisher.
    private var pokemonCharacterSubscriber: AnyCancellable?
   
    @IBOutlet private weak var pokemonName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonViewModel = PokemonViewModel(pokemonFetcher: PokemonFetcher(), number: 807)
        pokemonCharacterSubscriber = pokemonViewModel?.$pokemonCharacter.sink() { [weak self] pokemon in
            self?.pokemonName.text = pokemon?.name
        }
    }
    
    
    @IBAction func updatePokemon(_ sender: UIButton) {
        let randomPokemon = Int.random(in: 1...807)
        pokemonViewModel?.updateView(for: randomPokemon)
    }
}
