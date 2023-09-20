//
//  File.swift
//  event-finder
//
//  Created by Indra Kumar on 4/21/23.
//

import Foundation


struct TicketmasterResponse: Codable {
    let _embedded: Embedded
    
   
}
struct Embedded: Codable {
    let events: [Event]
    
    struct Event: Codable {
        let name: String?
        let id: String
        let url: String
        let images: [Image]
        let dates: Dates
        let classifications: [Classification]
        let priceRanges: [PriceRange?]?
        let seatmap: Seatmap?
        let _embedded:VenueEmbedded
        
        struct Image: Codable {
            let url: String
            let width: Int
            let height: Int
        }
        
        struct Dates: Codable {
            let start: Start
            let status: Status
            
            struct Start: Codable {
                let localDate: String?
                let localTime: String?
                let dateTime: String?
            }
            struct Status: Codable{
                let code:String?
            }
        }
        
        struct Classification: Codable {
            let primary: Bool?
            let segment: Genre?
            let genre: Genre?
            let subGenre: Genre?
            let type: Genre?
            let subType: Genre?
            let family: Bool?
            
            struct Genre: Codable {
                let id: String?
                let name: String?
            }
        }
        
        struct PriceRange: Codable {
            let type: String?
            let currency: String?
            let min: Float?
            let max: Float?
        }
        
        struct Seatmap: Codable {
            let staticUrl: String?
        }
        
        
        struct VenueEmbedded:Codable{
            
            let venues:[Venue]?;
            let attractions:[Artist]?;
            struct Venue:Codable{
                let name:String?
                let type:String;
                let id:String;

                
            }
            struct Artist:Codable{
                let name:String;
                let id:String;
            }
            
            
        }
    }
}
