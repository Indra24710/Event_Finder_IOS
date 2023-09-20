//
//  GMapLocModel.swift
//  event-finder
//
//  Created by Indra Kumar on 5/4/23.
//

import Foundation

struct GMapLocModel:Codable{
    
    let results:[subLocModel];
    
    struct subLocModel:Codable{
        let geometry:Geometry;
    
        
        struct Geometry:Codable{
            
            let location: location
            struct location:Codable{
                let lat:Double;
                let lng:Double;
            }
            
        }
    }
    
}
