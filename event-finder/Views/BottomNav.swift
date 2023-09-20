//
//  BottomNav.swift
//  event-finder
//
//  Created by Indra Kumar on 4/27/23.
//

import SwiftUI

struct BottomNav: View {
    @State var eventsObj:[Embedded.Event]=[];
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dynEventData=DynamicEventData();
    @State var artistArrLen=0;
    @State var forceLoad:Bool=false;
    
//    init(eventsObj:[Embedded.Event]){
//        self.eventsObj=eventsObj;
//        dynEventData.eventsObj=eventsObj;
//
//    }
    
    
    var body: some View {
        VStack{
//            HStack{
//                Image(systemName: "chevron.left")
//                Text("Event Search")
//                Spacer()
//            }.padding([.top,.leading],20)
            if self.artistArrLen>0 && dynEventData.artists.count >= Int(0.25*Double(self.artistArrLen)) && forceLoad{
                TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                    Event(eventsObj: $eventsObj).tabItem {Image(systemName:"text.bubble.fill")
                        Text("Events")
                    }.tag(1)
                    Artist(artistObj:dynEventData.artists).tabItem { Image(systemName:"guitars")
                        Text("Artist/Teams")
                        
                    }.tag(2)
                    Venue(eventsObj: $eventsObj).tabItem { Image(systemName: "location.fill")
                        Text("Venue")
                        
                    }.tag(2)
                    
                }
                
            }
            else{
               
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            ProgressView()
                            Text("Please wait...").foregroundColor(Color.gray)
                        }.onAppear(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                forceLoad = true
                            }
                        }
                        Spacer()
                    }
                    
                    Spacer()
            }
            
        }.onAppear(){
            dynEventData.eventsObj = self.eventsObj;

            if let artistArr = eventsObj[0]._embedded.attractions{
                self.artistArrLen=artistArr.count
                for artist in artistArr{
                    dynEventData.getArtistDetails(artistName: artist.name)
                }
                print("artist length",self.artistArrLen)
                
            }
            
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                // Custom action on back button press, if needed.
                // For example, you can use the presentation mode to dismiss the view:
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Event Search")
                }
            })
        
    }
    

}

//struct BottomNav_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomNav()
//    }
//}
