//
//  Venue.swift
//  event-finder
//
//  Created by Indra Kumar on 4/27/23.
//

import SwiftUI
struct MakeTextScrollable: View {
    let text: String
    let nlines: Int
    let fontSize:CGFloat;

    init(text: String, nlines: Int, fontSize:CGFloat) {
        self.text = text
        self.nlines = nlines
        self.fontSize=fontSize
    }

    func createlines() -> [String] {
        let textToWords = text.split(separator: " ")
        var currLine = ""
        var out: [String] = []

        for word in textToWords {
            let newLine = currLine.isEmpty ? String(word) : "\(currLine) \(word)"
            if newLine.size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)]).width <= UIScreen.main.bounds.width - 40 {
                currLine = newLine
            } else {
                out.append(currLine)
                currLine = String(word)
            }
        }
        out.append(currLine)
        return out
    }

    var body: some View {
        let totalHeight = CGFloat(nlines) * (fontSize + 2) // Adjust 2 to change the line spacing

// Adjust 2 to change the line spacing
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 2) {
                ForEach(createlines(), id: \.self) { line in
                    Text(line).foregroundColor(Color.gray)
                }
            }
//            .padding(.horizontal)
        }.frame(height: totalHeight)
    }
}



struct Venue: View {
    @State var GRtext:String="";
    @Binding var eventsObj:[Embedded.Event];

    @State var VenueInfoArr:[VenueAPIModel]=[];
    
    @State var showMap:Bool = false;
    @State var latitude:Double=0.0;
    @State var longitude:Double=0.0;
    var body: some View {
        
        VStack{
            if(!$VenueInfoArr.isEmpty){
                Text($eventsObj[0].wrappedValue.name ?? "").font(.title2).bold().padding([.top,.bottom],20)
                
                VStack{
                    Text("Name").bold()
                    Text($VenueInfoArr[0].wrappedValue.name).foregroundColor(Color.gray)
                }.padding(.bottom,10)
                VStack{
                    Text("Address").bold()
                    Text($VenueInfoArr[0].wrappedValue.address.line1).foregroundColor(Color.gray)
                }.padding(.bottom,10)
                VStack{
                    Text("Phone Number").bold()
                    if var phObj:String = $VenueInfoArr[0].wrappedValue.boxOfficeInfo?.phoneNumberDetail{
                        if var phVal:String = extractPhoneNumber(from:phObj){
                            Text(phVal).foregroundColor(Color.gray)}
                        else{
                            Text("N/A").foregroundColor(Color.gray)
                        }
                        
                    }
                    else{
                        Text("N/A").foregroundColor(Color.gray)
                    }
                }.padding(.bottom,10)
                VStack{
                    Text("Open Hours").bold()
                    if var ohi = $VenueInfoArr[0].wrappedValue.boxOfficeInfo?.openHoursDetail{
                        MakeTextScrollable(text: ohi, nlines: 3, fontSize:20)
                    }
                    else{
                        Text("N/A").foregroundColor(Color.gray)
                    }
                    
                }.padding(.bottom,10)
                VStack{
                    Text("General Rule").bold()
                    if var genRule = $VenueInfoArr[0].wrappedValue.generalInfo?.generalRule{
                        MakeTextScrollable(text: genRule, nlines: 3, fontSize:20)

                        
                        
                    }
                        else{
                        Text("N/A").foregroundColor(Color.gray)
                    }
                }.padding(.bottom,10)
                VStack{
                    Text("Child Rule").bold()
                    if var childRule = $VenueInfoArr[0].wrappedValue.generalInfo?.childRule{
                        MakeTextScrollable(text: childRule, nlines: 3, fontSize:20)

                        
                    }
                        else{
                        Text("N/A").foregroundColor(Color.gray)
                    }
                }.padding(.bottom,10)
                
                Button("Show venue on maps") {
                    showMap=true;
                }.padding([.top,.bottom,.leading,.trailing],10).background(Color(UIColor.systemRed).cornerRadius(10)).foregroundColor(Color.white)
                Spacer()
                
                
            }
            
        }
        .onAppear(){
            loadVenueData()
        }
        .sheet(isPresented:$showMap){
            MapView(latitude: latitude, longitude: longitude)
        }
        
    }
    
    
    func loadVenueData(){
        
        if let venueList=eventsObj[0]._embedded.venues, var venueName=venueList[0].name{
            
            venueName=venueName.replacingOccurrences(of: " ", with: "%20")

            let urlString = "https://wbtech571ik-377921.wl.r.appspot.com/getVenueData?name=" + venueName;
            print("venue",urlString,venueName)
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching Venue suggestions: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let decoder=JSONDecoder()
                    //                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let fetchedApiResponse = try decoder.decode(VenueAPIModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        //                        if var res:ArtistModel = fetchedApiResponse.first{
                        //                            if let imgurl = res.imageUrl{
                        //                                print("Artist",imgurl) }
                        //
                        //                        }
                        
                        self.VenueInfoArr.append(fetchedApiResponse)
                        if let lat = Double(self.VenueInfoArr[0].location.latitude){
                            latitude = lat

                        }
                        if let longit = Double(self.VenueInfoArr[0].location.longitude){
                            longitude = longit

                        }
                        print("lat long",latitude,longitude)
//                        longitude=Double(self.VenueInfoArr[0].location.longitude)
//                        print("arr cont",self.VenueInfoArr)

                    }
                } catch {
                    print("Error decoding Artist suggestions: \(error.localizedDescription)")
                    if let dataString = String(data: data, encoding: .utf8) {
//                        print("Received data: \(dataString)")
                    }
                    DispatchQueue.main.async {
                    }
                }
            }.resume()}
        
    }
        
        
    func extractPhoneNumber(from string: String) -> String? {
        let regex = try! NSRegularExpression(pattern: "^\\s*(\\d{3})[- ](\\d{3})[- ](\\d{4})")
        let range = NSRange(location: 0, length: string.utf16.count)
        let match = regex.firstMatch(in: string, options: [], range: range)
        
        if let match = match {
            let areaCodeRange = Range(match.range(at: 1), in: string)!
            let prefixRange = Range(match.range(at: 2), in: string)!
            let lineNumberRange = Range(match.range(at: 3), in: string)!
            let areaCode = String(string[areaCodeRange])
            let prefix = String(string[prefixRange])
            let lineNumber = String(string[lineNumberRange])
            return "\(areaCode)-\(prefix)-\(lineNumber)"
        }else{
            return nil
        }
    }
    }

//
//struct Venue_Previews: PreviewProvider {
//    static var previews: some View {
//        Venue(GRtext: "")
//    }
//}
