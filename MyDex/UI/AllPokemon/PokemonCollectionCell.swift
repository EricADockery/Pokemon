//
//  PokemonCollectionCell.swift
//  MyDex
//
//  Created by Eric Dockery on 9/8/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import UIKit

class PokemonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var pokemonName: UILabel!
    
    var pokemon: TopLevelPokemon?
    
    func update(with pokemon: TopLevelPokemon) {
        self.pokemon = pokemon
        pokemonName.text = pokemon.name
    }
}
