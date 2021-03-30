//
//  PokemonFetcher.swift
//  MyDex
//
//  Created by Eric Dockery on 3/21/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import Combine
import Foundation

class Fetcher {
    //only has pokemon up to 807 (missing Sword / Shield and meltan / melmetal)
    let baseURLString = "https://pokeapi.co"
    
    func networkRequest(url: URL, body: Data? = nil, authenticated: Bool = false ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

class PokemonFetcher: Fetcher {
    
    private let pokemonEndpoint = "/api/v2/pokemon/"
        
    func pokemon(for location: String) -> AnyPublisher<PokemonCharacter, Swift.Error>  {
        //force unwrap because I don't know how to guard return error here...
        guard let pokemonURL = URL(string: location) else {
            let error = NetworkError.malformedURL
            return Fail(error: error).eraseToAnyPublisher()
        }
        let urlRequest = networkRequest(url: pokemonURL)
        return NetworkClient.shared.performCodableRequest(urlRequest)
    }
    
    func allPokemon(for locations: [String]) -> AnyPublisher<[PokemonCharacter], Swift.Error> {
        return Publishers.MergeMany(locations.map { pokemon(for: $0)})
            .collect()
            .eraseToAnyPublisher()
    }
    
    func fetchAllPokemon() -> AnyPublisher<AllPokemon?, Swift.Error> {
        //https://pokeapi.co/api/v2/pokemon/?offset=0&limit=9999
        guard let pokemonURL = URL(string: "\(baseURLString)\(pokemonEndpoint)?offset=0&limit=898") else {
            let error = NetworkError.malformedURL
            return Fail(error: error).eraseToAnyPublisher()
        }
        let urlRequest = networkRequest(url: pokemonURL)
        return NetworkClient.shared.performCodableRequest(urlRequest)
    }
}
