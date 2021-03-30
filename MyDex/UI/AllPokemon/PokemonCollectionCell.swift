//
//  PokemonCollectionCell.swift
//  MyDex
//
//  Created by Eric Dockery on 9/8/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import UIKit

class PokemonCollectionCell: BaseReuseCollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    var pokemon: PokemonCharacter?
    
    func update(with pokemon: PokemonCharacter) {
        self.pokemon = pokemon
        pokemonName.text = pokemon.name
        if let spriteLocation = pokemon.sprites.frontDefault ?? pokemon.sprites.frontShiny,
           let url = URL(string: spriteLocation)
        {
            imageView.loadImage(at: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        imageView.cancelImageLoad()
    }
}
