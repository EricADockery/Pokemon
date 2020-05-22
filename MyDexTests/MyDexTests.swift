//
//  MyDexTests.swift
//  MyDexTests
//
//  Created by Eric Dockery on 3/21/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import XCTest
@testable import MyDex

class MyDexTests: XCTestCase {

    func testDecodingButterFree() {
        let butterFreeData = data(for: "Butterfree")
        let decoder = JSONDecoder()
        guard let butterfree = try? decoder.decode(PokemonCharacter.self, from: butterFreeData)
            else {
                XCTFail("Failed to decode Butterfree")
                return
        }
        XCTAssert(true, "Found Butterfree \(butterfree)")
    }
    
    func testDecodingAllPokemon() {
        let allPokemonData = data(for: "allPokemon")
        let decoder = JSONDecoder()
        guard let allPokemon = try? decoder.decode(AllPokemon.self, from: allPokemonData) else {
            XCTFail("Failed to decode all pokemon data response")
            return
        }
        XCTAssert(true, "Found all pokemon data \(allPokemon)")
    }
}

func data(for fileName: String) -> Data {
    let testBundle = Bundle(for: MyDexTests.self)
       let fileUrl = testBundle.url(forResource: fileName, withExtension: "json")!
       let searchData = try! Data(contentsOf: fileUrl)
       return searchData
   }
