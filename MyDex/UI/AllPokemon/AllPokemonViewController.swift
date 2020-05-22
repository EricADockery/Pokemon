//
//  AllPokemonViewController.swift
//  MyDex
//
//  Created by Eric Dockery on 3/22/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import UIKit
import Combine

class AllPokemonViewModel: ObservableObject, Identifiable {
    
    @Published var allPokemon: AllPokemon?
    
    // disposables keep the network request alive
    private var disposables = Set<AnyCancellable>()
    
    private let pokemonFetcher: PokemonFetcher
    
    init(pokemonFetcher: PokemonFetcher) {
        self.pokemonFetcher = pokemonFetcher
        pokemonFetcher.fetchAllPokemon().sink(receiveCompletion: { error in
            switch error {
            case .failure(let error):
                print("Error: \(error.self)")
            case .finished:
                print("Successful completion")
            }
        }) { [weak self] allPokemon in
            self?.allPokemon = allPokemon
        }
        .store(in: &disposables)
    }
}

class PokemonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var pokemonName: UILabel!
    
    func update(name: String) {
        pokemonName.text = name
    }
}

class AllPokemonViewController: UIViewController {
    private var pokemonSubscriber: AnyCancellable?
    private var allPokemonViewModel: AllPokemonViewModel?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPokemonViewModel = AllPokemonViewModel(pokemonFetcher: PokemonFetcher())
        //Don't forget the dollar sign yo
        pokemonSubscriber = allPokemonViewModel?.$allPokemon.sink() { [weak self] allPokemon in
            self?.activityIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
}

//MARK: UICollectionViewDelegate
extension AllPokemonViewController: UICollectionViewDelegate {
}

//MARK: UICollectionViewDataSource
extension AllPokemonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPokemonViewModel?.allPokemon?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionCell", for: indexPath) as? PokemonCollectionCell,
            let name = allPokemonViewModel?.allPokemon?.results[indexPath.row].name
            else {
                return UICollectionViewCell()
        }
        cell.update(name: name)
        return cell
    }
}
