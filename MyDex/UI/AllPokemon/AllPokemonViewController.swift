//
//  AllPokemonViewController.swift
//  MyDex
//
//  Created by Eric Dockery on 3/22/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import UIKit
import Combine // needed for AnyCancellable in the view controller

enum PokemonSection: CaseIterable {
    case main
}

class AllPokemonViewController: UIViewController {
    private var pokemonSubscriber: AnyCancellable?
    private var allPokemonViewModel: AllPokemonViewModel?
    //we have to store a reference so that when we call applySnapshot it works (also it will deallocate?? when we don't have it stored.
    private lazy var dataSource = makeDataSource()
    
    private var selectedPokemon: TopLevelPokemon?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBSegueAction private func pokemonDetailSegue(_ coder: NSCoder) -> PokemonViewController? {
        guard let selectedPokemon = selectedPokemon else {
            return nil
        }
        let pokemonDetailViewModel = PokemonViewModel(pokemonFetcher: PokemonFetcher(), topLevelPokemon: selectedPokemon)
        let viewController = PokemonViewController(coder: coder, pokemonViewModel: pokemonDetailViewModel)
        return viewController
    }
    
    
}

//MARK: DataSource Methods
extension AllPokemonViewController {
    
    func makeDataSource() ->  UICollectionViewDiffableDataSource<PokemonSection, TopLevelPokemon> {
        let dataSource = UICollectionViewDiffableDataSource<PokemonSection, TopLevelPokemon>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, topLevelPokemon) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "PokemonCollectionCell",
                    for: indexPath) as? PokemonCollectionCell
                
                cell?.update(with: topLevelPokemon)
                return cell
            })
        return dataSource
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PokemonSection, TopLevelPokemon>()
        snapshot.appendSections(PokemonSection.allCases)
        snapshot.appendItems(allPokemonViewModel?.allPokemon?.results ?? [], toSection: .main)
        (collectionView.dataSource as?  UICollectionViewDiffableDataSource<PokemonSection, TopLevelPokemon>)?.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: UICollectionViewDelegate
extension AllPokemonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPokemon = allPokemonViewModel?.allPokemon?.results[indexPath.row]
        performSegue(withIdentifier: "PokemonDetails", sender: nil)
    }
}

//MARK: UICollectionViewFlowDelegate
extension AllPokemonViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100.0)
    }
}

//MARK: Private Methods
private extension AllPokemonViewController {

    func setupView() {
        self.title = "Find A Pokemon"
        allPokemonViewModel = AllPokemonViewModel(pokemonFetcher: PokemonFetcher())
        collectionView.dataSource = dataSource
        //Don't forget the dollar sign when referencing publishers
        pokemonSubscriber = allPokemonViewModel?.$allPokemon.sink() { [weak self] allPokemon in
            guard !(allPokemon?.results.isEmpty ?? true) else { return }
            self?.activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                self?.applySnapshot()
            }
        }
    }
}
