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

enum PokemonSection: CaseIterable {
    case main
}

class PokemonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var pokemonName: UILabel!
    
    var pokemon: TopLevelPokemon?
    
    func update(with pokemon: TopLevelPokemon) {
        self.pokemon = pokemon
        pokemonName.text = pokemon.name
    }
}

class AllPokemonViewController: UIViewController {
    private var pokemonSubscriber: AnyCancellable?
    private var allPokemonViewModel: AllPokemonViewModel?
    //for some reason when in the .sink() method the allPokemonViewModels allPokemon is empty even though the subscriber returns it/
    private var allPokemon = [TopLevelPokemon]()
    //we have to store a reference so that when we call applySnapshot it works (also it will deallocate?? when we don't have it stored.
    private lazy var dataSource = makeDataSource()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allPokemonViewModel = AllPokemonViewModel(pokemonFetcher: PokemonFetcher())
        collectionView.dataSource = dataSource
        //Don't forget the dollar sign yo
        pokemonSubscriber = allPokemonViewModel?.$allPokemon.sink() { [weak self] allPokemon in
            guard !(allPokemon?.results.isEmpty ?? true) else { return }
            self?.activityIndicator.stopAnimating()
            self?.allPokemon = allPokemon?.results ?? []
            self?.applySnapshot()
        }
    }
}

//MARK: Delegate Methods
extension AllPokemonViewController {
    
    func makeDataSource() ->  UICollectionViewDiffableDataSource<PokemonSection, TopLevelPokemon> {
        let dataSource = UICollectionViewDiffableDataSource<PokemonSection, TopLevelPokemon>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "PokemonCollectionCell",
                    for: indexPath) as? PokemonCollectionCell
                cell?.update(with: self.allPokemon[indexPath.row])
                return cell
        })
        return dataSource
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PokemonSection, TopLevelPokemon>()
        snapshot.appendSections(PokemonSection.allCases)
        snapshot.appendItems(allPokemon, toSection: .main)
        (collectionView.dataSource as?  UICollectionViewDiffableDataSource<PokemonSection, TopLevelPokemon>)?.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: UICollectionViewDelegate
extension AllPokemonViewController: UICollectionViewDelegate {
}
