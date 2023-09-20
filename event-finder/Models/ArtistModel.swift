//
//  ArtistModel.swift
//  event-finder
//
//  Created by Indra Kumar on 4/29/23.
//

import Foundation


struct ArtistModel: Codable,Identifiable {
    let id: String?
    let name: String?
    let followers: String?
    let spotifyLink: String?
    let popularity: String?
    let imageUrl: Image?
    let albums: [String]?
    struct Image: Codable {
        let height: Int
        let url: String
        let width: Int
        
        enum CodingKeys: String, CodingKey {
            case height
            case url
            case width
        }
    }
    enum CodingKeys: String, CodingKey {
        case name
        case followers
        case spotifyLink = "spotify_link"
        case popularity
        case imageUrl = "imageUrl"
        case id
        case albums
    }








}



