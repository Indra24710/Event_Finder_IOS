//
//  Artist.swift
//  event-finder
//
//  Created by Indra Kumar on 4/27/23.
//

import SwiftUI

struct Artist: View {
    //    @ObservedObject var dynamicArtistView = DynamicArtistView();
    var artistObj:[ArtistModel]=[];
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                if(artistObj.isEmpty){
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Text("No music related artist details to show").font(.title).foregroundColor(Color.black).multilineTextAlignment(.center).bold()
                            Spacer()
                            
                        }
                        Spacer()}
                }else{
                    ScrollView{
                        VStack{
                            ForEach(artistObj){ artist in
                                ArtistCard(artist:artist).padding([.top,.bottom],15)
                            }
                            //            }.onAppear(){
                            //                for artist in eventsObj[0]._embedded.attractions{
                            //                    dynamicArtistView.getArtistDetails(artistName:artist.name);
                            //                }
                            //
                            //            }
                            
                        }
                        
                        
                    }
                }
                
            }
            Spacer()

        }
        
        
        
        
        
    }
}

//struct Artist_Previews: PreviewProvider {
//    static var previews: some View {
//        Artist()
//    }
//}
