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
}

func data(for fileName: String) -> Data {
    let testBundle = Bundle(for: MyDexTests.self)
       let fileUrl = testBundle.url(forResource: fileName, withExtension: "json")!
       let searchData = try! Data(contentsOf: fileUrl)
       return searchData
   }
