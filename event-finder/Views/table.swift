//
//  table.swift
//  event-finder
//
//  Created by Indra Kumar on 4/20/23.
//

import SwiftUI
import Combine

struct table: View {
    @Binding var fetchedEmbeddedObject:Embedded;
    @State var eventsArr: [Array<String>] = [];
    


    
    var body: some View {

        ZStack{
            Color(.white).cornerRadius(20);
            VStack(alignment: .leading) {
                HStack {
                    Text("Results")
                        .font(.title)
                        .bold()
                        .padding(10)
                        .alignmentGuide(.leading) { _ in 0 }
                    Spacer()
                }
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .offset(y: 30)
                )
                
                
                VStack{
                  
                        
                        ScrollView{    List($eventsArr, id: \.self){event in
                            
                            if let index=Int(event[4].wrappedValue){
                                NavigationLink(destination:BottomNav(eventsObj:[self.fetchedEmbeddedObject.events[index]])){
                                    HStack{
                                        // Represents row elements
                                        Text(event[0].wrappedValue)
                                        Spacer()
                                        AsyncImage(url: URL(string: event[1].wrappedValue)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            
                                        }
                                        Spacer()
                                        
                                        Text(event[2].wrappedValue)
                                        Spacer()
                                        
                                        Text(event[3].wrappedValue)
                                    }
                                }
                            }
                            
                        }.listStyle(PlainListStyle()).frame(maxWidth: .infinity) // <-- Fill the ScrollView horizontally
                                .frame(height: 250).font(.subheadline)
                            
                        }
                    
                
                    
                    
                    
                }
                
            }.border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding(.horizontal,20).onAppear(){
                createTable();
            }
            
        }.padding([.leading,.trailing],10).padding(.top,15)
    }
    func createTable(){
        
//        print("from table",self.fetchedEmbeddedObject)
        var newEvents: [Array<String>] = []
        var count=0;
        for event in self.fetchedEmbeddedObject.events{
            var localDate=event.dates.start.localDate ?? ""
            let localTime=event.dates.start.localTime ?? ""
            let eventName=event.name ?? ""
            var venueName=" "
            if let venues = event._embedded.venues, !venues.isEmpty, let venue = venues[0].name {
                
                venueName=venue
            }
            let imageURL = event.images[0].url;
            let newEventObject=[localDate+" | "+localTime,imageURL,eventName,venueName,String(count)]
            newEvents.append(newEventObject);
            count+=1;
            
            
        }
        print("events",newEvents)
        newEvents.sort{ $0[0] < $1[0] }
        eventsArr=newEvents;
        
        
    }
    
    
    
}

//struct table_Previews: PreviewProvider {
//    static var previews: some View {
//        var embeddedObject = Embedded(events: [])
//                let binding = Binding<Embedded>(get: { embeddedObject }, set: { embeddedObject = $0 })
//                return table(fetchedEmbeddedObject: binding)    }
//}
