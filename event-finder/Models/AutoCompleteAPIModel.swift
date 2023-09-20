//
//  keywordAutocompleteAPIModel.swift
//  event-finder
//
//  Created by Indra Kumar on 4/20/23.
//

import Foundation

   public struct ApiResponse: Codable {
        let _embedded: EmbeddedObject
    }
    
public  struct EmbeddedObject: Codable {
        let attractions: [Attraction]
    }
    
public struct Attraction: Codable, Identifiable {
       public let id: String
        let name: String
        
    }

