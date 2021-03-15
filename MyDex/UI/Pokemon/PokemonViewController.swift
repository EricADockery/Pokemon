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
        
    let pokemonViewModel: PokemonViewModel
    
    //subscribes to the data change on the publisher.
    private var pokemonCharacterSubscriber: AnyCancellable?
        
    @IBOutlet private weak var pokemonName: UILabel!
    
    init?(coder: NSCoder, pokemonViewModel: PokemonViewModel) {
        self.pokemonViewModel = pokemonViewModel
        super.init(coder: coder)
        self.pokemonViewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Detail View"
        pokemonCharacterSubscriber = pokemonViewModel.$pokemonCharacter.sink() { [weak self] pokemon in
            self?.pokemonName.text = pokemon?.name
        }
    }
}

extension PokemonViewController: PokemonDetailViewConformance {
    func dismissOnBackground() {
        self.navigationController?.popViewController(animated: false)
    }
}
