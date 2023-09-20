//
//  ArtistCard.swift
//  event-finder
//
//  Created by Indra Kumar on 4/27/23.
//

import SwiftUI

struct ArtistCard: View {
    @State var artist:ArtistModel;
    var body: some View {
        VStack{
            //        Primary Card
            VStack{
                
                //        Top half
                HStack{
                    Spacer()
                    if let imageURLObj = artist.imageUrl{
                        AsyncImage(url: URL(string: imageURLObj.url)){ image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 125, height: 125)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 125, height: 125)
                    }
                    Spacer()
                    
                    VStack{
                        HStack{
                            VStack{
                                Spacer()
                                
                                Text(artist.name ?? "").bold().font(.title2)
                                Spacer()
                                HStack{
                                    Text(formatNumber(number:artist.followers ?? "0")).bold()
                                         Text("Followers")
                                }
                                
                                Spacer()
                                
                                
                            }
                            Spacer()
                            
                            VStack{
                                
                                Spacer()
                                Text("Popularity")
                                Spacer()
                                //                        Text(artist.popularity)
                                ZStack{
                                    Circle()
                                        .trim(from: 0, to: CGFloat(Int(artist.popularity ?? "0") ?? 0)/100)
                                        .stroke(Color.orange, lineWidth: 12)
                                        .frame(width: 50, height: 50)
                                    Spacer()
                                    Text(artist.popularity ?? "")
                                    
                                }
                                Spacer()
                            }}
                        Spacer()
                        
                        HStack{
                            Spacer()
                            if let spotifyLink = artist.spotifyLink{
                                if let url = URL(string: spotifyLink) {
                                    Link(destination: url) {
                                        Image("spotify").resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 150, height: 30)
                                    }
                                }
                                
                            }
                            
                            
                            
                            Spacer()
                            
                            
                        }
                        
                    }
                    Spacer()
                    
                    
                }
                Spacer()
                
            }.padding(.bottom,15).padding(.top,20)
            //        Bottom half
            VStack{
                HStack{
                    Text("Popular Albums").font(.title).bold().padding(.leading,20)
                    Spacer()
                }.padding(.bottom,10)
                
                //                Album list
                HStack{
                    if let albums = artist.albums{
                    ForEach(albums ?? [],id:\.self){album in
                            Spacer()
                            AsyncImage(url: URL(string: album)){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            Spacer()
                        }
                        
                    }
                    
                }
            }.padding(.bottom,20)
            
            
        }.background(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.90).cornerRadius(20))
            .foregroundColor(Color.white)
            .padding([.leading,.trailing],5)
        
    }
        
        
    
    
    func formatNumber( number: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        let num = Double(number) ?? 0
        let thousand = num / 1000.0
        let million = num / 1000000.0
        let billion = num / 1000000000.0
        if billion >= 1.0 {
            return formatter.string(from: NSNumber(value: billion))! + "B"
        } else if million >= 1.0 {
            return formatter.string(from: NSNumber(value: million))! + "M"
        } else if thousand >= 1.0 {
            return formatter.string(from: NSNumber(value: thousand))! + "K"
        } else {
            return formatter.string(from: NSNumber(value: num))!
        }
    }
    
    
}

//struct ArtistCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtistCard()
//    }
//}
