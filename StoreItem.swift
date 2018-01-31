//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Andres Gutierrez on 1/30/18.
//  Copyright © 2018 Andres Gutierrez. All rights reserved.
//

import Foundation

struct StoreItem: Codable {
    var kind: String
    var artist: String
    var trackName: String
    var album: String
    var genre: String
    var artwork: URL
    var trackTimeMillis: Int
    var trackPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case kind
        case artist = "artistName"
        case trackName
        case album = "collectionName"
        case genre = "primaryGenreName"
        case artwork = "artworkUrl100"
        case trackPrice
        case trackTimeMillis
    }
    
    enum additionalKeys: String, CodingKey {
        case trackCensoredName
    }
    
    init(from decoder: Decoder) throws {
        let keyedCodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        kind = try keyedCodingContainer.decode(String.self, forKey: CodingKeys.kind)
        artist = try keyedCodingContainer.decode(String.self, forKey: CodingKeys.artist)
        album = try keyedCodingContainer.decode(String.self, forKey: CodingKeys.album)
        genre = try keyedCodingContainer.decode(String.self, forKey: CodingKeys.genre)
        artwork = try keyedCodingContainer.decode(URL.self, forKey: CodingKeys.artwork)
        trackTimeMillis = try keyedCodingContainer.decode(Int.self, forKey: CodingKeys.trackTimeMillis)
        trackPrice = try keyedCodingContainer.decode(Double.self, forKey: CodingKeys.trackPrice)
        
        
        // This is in to add data in case the 'specific' data is not found and another could be used.
        if let trackName = try? keyedCodingContainer.decode(String.self, forKey: CodingKeys.trackName) {
            self.trackName = trackName
        } else {
            let additionalKeyedCodingCont = try decoder.container(keyedBy: additionalKeys.self)
            trackName = (try? additionalKeyedCodingCont.decode(String.self, forKey: additionalKeys.trackCensoredName)) ?? ""
        }
    }
}

struct StoreItems: Codable {
    let results: [StoreItem]
}
