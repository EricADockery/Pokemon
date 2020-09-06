//
//  PokemonCharacter.swift
//  MyDex
//
//  Created by Eric Dockery on 3/21/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import Foundation

struct Type: Codable {
    let name: String
    let url: String
}

struct Types: Codable {
    let slot: Int
    let type: Type
}

struct Stat: Codable {
    let name: String
    let url: String
}

struct Stats: Codable {
    let baseStat: Int //base_stat
    let effort: Int
    let stat : Stat
    
    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct Sprites: Codable {
    let backFemale: String? //back_female
    let backShinyFemale: String? // back_shiny_female
    let backDefault: String? // back_default
    let frontFemale: String? // front_female
    let frontShinyFemale: String? // front_shiny_female
    let backShiny: String? // back_shiny
    let frontDefault: String? // front_default
    let frontShiny: String? // front_shiny
    
    private enum CodingKeys: String, CodingKey {
        case backFemale = "back_female"
        case backShinyFemale = "back_shiny_female"
        case backDefault = "back_default"
        case frontFemale = "front_female"
        case frontShinyFemale = "front_shiny_female"
        case backShiny = "back_shiny"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct Species: Codable {
    let name: String
    let url: String
}

struct MoveLearnMethod: Codable {
    let name: String
    let url: String
}

struct VersionGroup: Codable {
    let name: String
    let url: String
}

struct VersionGroupDetails: Codable {
    let levelLearned: Int // level_learned_at
    let versionGroup: VersionGroup //version_group
    let moveLearnMethod: MoveLearnMethod //move_learn_method
    
    private enum CodingKeys: String, CodingKey {
        case levelLearned = "level_learned_at"
        case versionGroup = "version_group"
        case moveLearnMethod = "move_learn_method"
    }
}

struct MoveDetail: Codable {
    let name: String
    let url: String
}

struct Move: Codable {
    let move: MoveDetail
    let versionGroupDetails: [VersionGroupDetails] //version_group_details
    
    private enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
    
}

struct EncounterMethod: Codable {
    let name: String
    let url: String
}

struct ConditionValues: Codable {
    let name: String
    let url: String
}

struct EncounterDetails: Codable {
    let minimumLevel: Int //"min_level"
    let maximumLevel: Int //"max_level"
    let conditionValues: [ConditionValues] // condition_values
    let chance: Int
    let method: EncounterMethod
    
    private enum CodingKeys: String, CodingKey {
        case minimumLevel = "min_level"
        case maximumLevel = "max_level"
        case conditionValues = "condition_values"
        case chance
        case method
    }
}

struct LocationVersionDetails: Codable {
    let maxChance: Int // max_chance
    let encounterDetails: [EncounterDetails] // encounter_details
    let version: Version
    private enum CodingKeys: String, CodingKey {
        case maxChance = "max_chance"
        case encounterDetails = "encounter_details"
        case version
    }
}

struct LocationArea: Codable {
    let name: String
    let url: String
}

struct LocationAreaEncounters: Codable {
    let locationArea: LocationArea
    let locationVersionDetails: [LocationVersionDetails] // version_details
    
    private enum CodingKeys: String, CodingKey {
        case locationArea = "location_area"
        case locationVersionDetails = "version_details"
    }
}

struct VersionDetails: Codable {
    let rarity: Int
    let version: Version
}

struct Item: Codable {
    let name: String
    let url: String
}

struct HeldItems: Codable {
    let item: Item
    let versionDetails: [VersionDetails] // version_details
    
    private enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
}

struct Version: Codable {
    let name: String
    let url: String
}

struct GameIndices: Codable {
    let gameIndex: Int // game_index
    let version: Version
    
    private enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

struct Forms: Codable {
    let name: String
    let url: String
}

struct Ability: Codable {
    let name: String
    let url: String
}

struct Abilities: Codable {
    let isHidden: Bool // is_hidden
    let slot: Int
    let ability: Ability
    
    private enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot
        case ability
    }
}

//GET /api/v2/pokemon/{id or name}/
struct PokemonCharacter: Codable {
    let id: Int
    let name: String
    let baseExperience: Int // base_experience
    let height: Int
    let isDefault: Bool // is_default
    let order: Int
    let weight: Int
    let abilities: [Abilities]
    let forms: [Forms]
    let gameIndices: [GameIndices ]// game_indices
    let heldItems: [HeldItems] // held_items
    let locationAreaEncounters: String // location_area_encounters
    let moves: [Move]
    let species: Species
    let sprites: Sprites
    let stats: [Stats]
    let types: [Types]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case isDefault = "is_default"
        case order
        case weight
        case abilities
        case forms
        case gameIndices = "game_indices"
        case heldItems = "held_items"
        case locationAreaEncounters = "location_area_encounters"
        case moves
        case species
        case sprites
        case stats
        case types
    }
}

struct TopLevelPokemon: Codable {
    let name: String
    let url: String
}

extension TopLevelPokemon: Hashable {
    
}

struct AllPokemon: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [TopLevelPokemon]
}
