//
//  Event.swift
//  event-finder
//
//  Created by Indra Kumar on 4/27/23.
//

import SwiftUI

struct Event: View {
    @Binding var eventsObj:[Embedded.Event];
    @State var eventName:String="";
    @State var localDate:String="";
    @State var localTime:String="";
    @State var artist:String="";
    @State var venue:String="";
    @State var priceRange:String="";
    @State var genre:String="";
    @State var ticketStatus:String="";
    @State var seatmapUrl:String="";
    @State var ticketUrl:String?;
    @State var fbUrl:String?;
    @State var twitterUrl:String?;

    @State var buttonColor:Color = Color.green;
    @State var eventSaved:Bool=false;
    @State var id:String="";
    @State private var showToast=false;
    @State private var toastMessage="";
    
    var body: some View {
        VStack{


            Text(eventName).padding(.top,20).bold().font(.title2)

            HStack{
                
                Text("Date").multilineTextAlignment(.leading).bold()
                Spacer()

                Text("Artist | Team").multilineTextAlignment(.trailing).bold()

                
                
            }.padding([.leading,.trailing],20).padding(.top,10)
            HStack{
                Text(localDate).foregroundColor(Color.gray).multilineTextAlignment(.leading)
                Spacer()
                if artist.count>0{
                    HStack{
                        Spacer()
                        MakeTextScrollable(text: artist, nlines: 2, fontSize:15)}.multilineTextAlignment(.trailing)
                }else{
                    Text("N/A").foregroundColor(Color.gray).multilineTextAlignment(.trailing)
                }
            }.padding([.leading,.trailing],20)
            

                HStack{
                    Text("Venue").bold()
                    Spacer()
                    Text("Genre").bold()

                }.padding([.leading,.trailing],20).padding(.top,3)
                HStack{
                    MakeTextScrollable(text: venue, nlines: 3, fontSize:15).foregroundColor(Color.gray)

                    Spacer()

                    MakeTextScrollable(text: genre, nlines: 3, fontSize:15).foregroundColor(Color.gray)
                
            }.padding([.leading,.trailing],20)

            HStack{
                    Text("Price Range").bold()
                Spacer()
                Text("Ticket Status").bold()

                }.padding([.leading,.trailing],20).padding(.top,3)
               HStack{
                   Text(priceRange).foregroundColor(Color.gray)

                    Spacer()

                    Button(ticketStatus) {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }.padding([.leading,.trailing],20).padding([.top,.bottom],8).background(buttonColor.cornerRadius(10)).foregroundColor(Color.white)
                }.padding([.leading,.trailing],20)
            

            Spacer()
            VStack{
                if !eventSaved{
                    Button("Save Event"){
                        
                        //                    save to favourites code
                        let jsonArray=[localDate,eventName,genre,venue,id]
    
                        appendJSONObject(jsonArray, toLocalStorageKey: "favouriteElements")
                        //                    print("saved array",jsonArray)
                        eventSaved=true
                        toastMessage="Added to favorites"
                        showToast=true;

                        
                    }.padding([.leading,.trailing],20).padding([.top,.bottom],8).background(Color(UIColor.systemBlue).cornerRadius(10)).foregroundColor(Color.white)
                    
                }else{
                    Button("Remove Favorite"){
                        
                        //                    save to favourites code
                        let jsonArray=[localDate,eventName,genre,venue,id]
    
                            deleteItem(id: id)
                        eventSaved=false;
                        toastMessage="Removed from favorites";
                        showToast=true;
                        
                    }.padding([.leading,.trailing],20).padding([.top,.bottom],8).background(Color(UIColor.systemRed).cornerRadius(10)).foregroundColor(Color.white)
                }
                
                Spacer()
                AsyncImage(url: URL(string: seatmapUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    // A placeholder image to show while the remote image is being loaded
//                                        Image(systemName: "event image")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
                }
                Spacer()

                HStack{
                    Text("Buy Ticket At:").bold()
                    if let url = ticketUrl.flatMap(URL.init){
                        Link("Ticketmaster",destination: url)
                             
                             }
                    else{
                        Text("Ticketmaster")
                    }
                }
                Spacer()

                HStack{
                    Text("Share on:").bold()
//                    if let url = fbUrl.flatMap(URL.init){
//                        Link(destination: url){
//                            Image("facebook")
//
//                        }
//
//                             }
                    if let url = ticketUrl, let fbUrl = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(url)") {
                        Link(destination: fbUrl) {
                            Image("facebook")
                        }
                    }
                    else{
                            Image("facebook")
                        
                    }
                    
                    if let url = ticketUrl, let tweetText = eventName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let tweetUrl = URL(string: "https://twitter.com/intent/tweet?url=\(url)&text=\(tweetText)") {
                        Link(destination: tweetUrl) {
                            Image("twitter")
                        }
                    }
                    else{
                        Image("twitter")

                    }
                }
                Spacer()
            }

            
        }.onAppear() {
            loadEventCard();
            
        }    .overlay(
            showToast ? CustomToastView(message: toastMessage, dismissAfter: 1.0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showToast = false
                    }
                }
                .onDisappear {
                    showToast = false
                } : nil,
            alignment: .bottom
        )

    }
    

    func deleteItem(id:String){
        
        var newjsonArray:[[Any]]=[];
        if let jsonArray=getLS(forKey: "favouriteElements"){
            var count=0
            for i in jsonArray {
                      if var i = i as? [String] {
                          
                          if !i.contains(id){
                              newjsonArray.append(i)
                          }
                       
                      }
                  }
            
            
        }
        
        saveLS(newjsonArray, forKey: "favouriteElements")
        eventSaved=false;
        print("flag",showToast)

        
        
        
        }
    
   
    func loadEventCard(){
        
        artist="";
        genre="";
        
        
        guard !eventsObj.isEmpty, let event = eventsObj.first else {
              print("The eventsObj array is empty.")
            
              return
          }
        id=event.id;
         localDate=event.dates.start.localDate ?? " "
        localTime=event.dates.start.localTime ?? " "
        
        
         eventName=event.name ?? " "
        
        if let venues = event._embedded.venues, !venues.isEmpty, let venueName = venues[0].name {
            
            venue=venueName
        }else{
            venue=" "
        }
//         venue=event._embedded.venues[0].name ?? " "
        
        
        if let value = event.classifications[0].segment?.name, value != "Undefined"{
            genre+=value
        }
        if let value=event.classifications[0].genre?.name, value != "Undefined"{
            genre+=" | " + value
        }
        
        if let value=event.classifications[0].subGenre?.name, value != "Undefined"{
            genre+=" | " + value
        }
        if let value=event.classifications[0].type?.name, value != "Undefined"{
            genre+=" | " + value
        }
        if let value=event.classifications[0].subType?.name, value != "Undefined"{
            genre+=" | " + value
        }
        
        var priceRangeMin = 0.0
        var priceRangeMax = 0.0
        if let value = event.priceRanges?[0]?.min{
            priceRangeMin = Double(value)
        }
        if let value = event.priceRanges?[0]?.max{
            priceRangeMax = Double(value)
        }
//        let priceRangeMin = event.priceRanges[0].min ?? 0
//        let priceRangeMax = event.priceRanges[0].max ?? 0
        
        if priceRangeMin != 0.0{
            priceRange=String(priceRangeMin)
        }
        if priceRangeMax != 0.0{
            if priceRangeMin != 0 {
                priceRange += " - "+String(priceRangeMax)
            }else{
                priceRange=String(priceRangeMax)
            }
        }
        if priceRangeMax == 0  && priceRangeMin == 0 {
            priceRange=" "
        }
        
        if let artistArr = event._embedded.attractions{
            
            let totalartistcount=artistArr.count
            var currcount=0
            for artistObj in artistArr{
                
                artist+=artistObj.name
                if currcount < totalartistcount-1{
                    artist+=" | "
                    currcount+=1
                }
                
            }
            
            
        }
        
      
        
        
        
        ticketStatus=event.dates.status.code ?? ""
        seatmapUrl = event.seatmap?.staticUrl ?? "";
        ticketUrl = event.url;
        if let url = ticketUrl {
            fbUrl = "https://www.facebook.com/sharer/sharer.php?u={{"+url+"}}"
            
        }else{
            
            fbUrl = "https://www.facebook.com/sharer/sharer.php?u={{}}"
        }
        updateButtonColor();
        eventSaved = checkEventInFavorite(id:id);
        
        
//        print(eventName,venue,priceRange,genre)

        
        
    }
    
    func checkEventInFavorite(id:String) ->Bool{
        if let jsonArray=getLS(forKey: "favouriteElements"){
            var count=0
            for i in jsonArray {
                      if var i = i as? [String] {
                          
                          if i.contains(id){
                              return true;
                          }
                       
                      }
                  }
            
            
        }
        
  return false
        
    }
    
    func getLS(forKey key: String) -> [Any]? {
        if let existingData = UserDefaults.standard.data(forKey: key) {
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: existingData, options: []) as? [Any]
                return jsonArray
            } catch {
                print("Error: Unable to deserialize existing JSON data.")
            }
        }
        return nil
    }
    func saveLS(_ jsonArray: [Any], forKey key: String) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            UserDefaults.standard.set(jsonData, forKey: key)
        } catch {
            print("Error: Unable to serialize JSON data.")
        }
        print("flag",showToast)


    }
    
    func appendJSONObject(_ jsonObject: Any, toLocalStorageKey key: String) {
        var jsonArray: [Any] = []

        if let existingJSONArray = getLS(forKey: key) {
            jsonArray = existingJSONArray
        }
        print("ls",jsonArray)

        jsonArray.append(jsonObject)
        saveLS(jsonArray, forKey: key)
    }

    
    private func updateButtonColor(){
        switch ticketStatus{
        case "onsale":
            buttonColor = Color.green
        case "offsale":
            buttonColor = Color.red
        case "canceled":
            buttonColor = Color.black
        case "postponed":
            buttonColor = Color.orange
        case "rescheduled":
            buttonColor = Color.orange
        default:
            buttonColor = Color.green
        }
    }
}

//
//struct Event_Previews: PreviewProvider {
//    static var previews: some View {
//        Event()
//    }
//}
