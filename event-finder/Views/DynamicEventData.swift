//
//  DynamicEventData.swift
//  event-finder
//
//  Created by Indra Kumar on 4/29/23.
//

import Foundation
import SwiftUI
import Combine

class DynamicEventData:ObservableObject{
    
    @Published var eventsObj:[Embedded.Event]=[]
    @Published var artists: [ArtistModel] = []

 
    
    
    func getArtistDetails(artistName:String){
            var artistName=artistName.replacingOccurrences(of: " ", with: "%20")
            let urlString = "https://wbtech571ik-377921.wl.r.appspot.com/getArtistData?name=" + artistName;
            print(urlString,artistName)
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching Artist suggestions: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let decoder=JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let fetchedApiResponse = try decoder.decode([ArtistModel].self, from: data)
                   
                    DispatchQueue.main.async {
//                        if var res:ArtistModel = fetchedApiResponse.first{
//                            if let imgurl = res.imageUrl{
//                                print("Artist",imgurl) }
//
//                        }
                        
                        self.artists.append(contentsOf:fetchedApiResponse)
                    }
                } catch {
                    print("Error decoding Artist suggestions: \(error.localizedDescription)")
                    if let dataString = String(data: data, encoding: .utf8) {
                           print("Received data: \(dataString)")
                       }
                    DispatchQueue.main.async {
                    }
                }
            }.resume()}
            
    
}
