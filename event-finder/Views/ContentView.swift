//
//  ContentView.swift
//  event-finder
//
//  Created by Indra Kumar on 4/13/23.
//

import SwiftUI
import Combine
import CoreLocation

struct ContentView: View {
    
    @State var keyword:String="";
    @State var distance:Int=10;
    @State var location:String="";
    @State var autoDetecttoggle:Bool=false;
    @State private var showingSuggestions = false;
    @State private var searchTextArray:[String]=[];
    @State private var getSuggestions=true;
    @State private var noMoreSuggestions=false;

    
//    Table related stuff
    @State var showTable=false;
    @State private var noTableData=false;
    @State private var fetchedEmbeddedObject=Embedded(events: []);
    @State private var TableObjectArray:Array<Any>=[];
    @State private var loadProgressView:Bool=false;
    @State private var latitude:Double=0.0;
    @State private var longitude:Double=0.0;
    @State private var currkeywordLength=0;
//    @StateObject private var locationManager = LocationManager()

    
    private func checkFormValidity() -> Bool{
        let testkeyword=keyword.replacingOccurrences(of: " ", with: "")
        let testlocation=location.replacingOccurrences(of: " ", with: "")
       return !testkeyword.isEmpty && (!testlocation.isEmpty || autoDetecttoggle)
    }
    
    enum eventCategories:String,CaseIterable,Identifiable{
        
        case Default
        case Music
        case Sports
        case AT = "Arts & Theatre"
        case Film
        case Miscellaneous
        var id:Self{self}
        
    }
    @State private var selectedCategory:eventCategories = .Default
    @State var prevSelectedKeyword:String="";

    
    var body: some View {
        NavigationView{
//            VStack{
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                VStack(spacing:-5){
                    //                        VStack{
                    //                            VStack {
                    //                                Spacer()
                  
                    VStack{
                        HStack{
                            Spacer()
                            NavigationLink(destination:Favourites()){
                                
                                Image(systemName:"heart.circle").padding(.trailing,20).foregroundColor(.blue).font(.system(size: 25))
                            }.padding(.top,10).padding([.trailing],10)
                        }
                        HStack{
                            Text("Event Search").font(.largeTitle).bold().padding(.leading,20)
                            Spacer()
                           
                            
                            
                        }
                    }
                    Form{
                        HStack {
                            Text("Keyword:").foregroundColor(.gray)
                            TextField("", text: $keyword, prompt: Text("required"))
                                .onReceive(Just(keyword)){
                                    
                                    input in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        let testkeyword=keyword.replacingOccurrences(of: " ", with: "")
                                        let testlocation=location.replacingOccurrences(of: " ", with: "")
                                        
                                        if keyword.count == currkeywordLength{
                                                getSuggestions=false;
                                        }else{
                                            getSuggestions=true;
                                        }
                                        
                                        if input == keyword && getSuggestions && !noMoreSuggestions{
                                            showingSuggestions = !testkeyword.isEmpty
                                            //
                                        }
                                    }
                                    
                                }
                        }

                        
                        HStack {
                            Text("Distance:").foregroundColor(.gray)
                            TextField("", text: Binding(get: {
                                "\(distance)"
                            }, set: {
                                if let value = Int($0) {
                                    distance = value
                                }
                            }))
                        }
                        HStack {
                            Text("Category:").foregroundColor(.gray)
                            Picker("", selection: $selectedCategory) {
                                ForEach(eventCategories.allCases) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }.accentColor(.blue).pickerStyle(.menu)
                        }
                        if(!autoDetecttoggle){
                            HStack {
                                Text("Location:").foregroundColor(.gray)
                                TextField("", text: $location, prompt: Text("required"))
                            }
                            
                        }
                        
                        HStack(spacing: -60){
                            Text("Auto-detect my location").foregroundColor(.gray)
                            Toggle(isOn: $autoDetecttoggle) {
                                
                            }.padding(.leading,0)
                        }
                        HStack{
                            Spacer()
                            Button("Submit"){} .padding([.top,.bottom],15).disabled(checkFormValidity()).onTapGesture {
                                if checkFormValidity(){
                                    print("form submitted");
                                    showTable=false;
                                    showingSuggestions=false;
                                    noMoreSuggestions=true;
                                    getSuggestions=false;
                                    loadProgressView=true;
                                    getTableparams();
                                }
                            }
                            .padding([.leading,.trailing],30).foregroundColor(.white) .background(checkFormValidity() ?  Color(.red):Color(.gray)).cornerRadius(10).bold()
                            Spacer()
                            Button("Clear") {
                                keyword="";
                                distance=10;
                                selectedCategory = .Default
                                location="";
                                getSuggestions=true;
                                showTable=false;
                                noMoreSuggestions=false;
                                autoDetecttoggle=false;
                                loadProgressView=false;
                                noTableData=false;
                            }.padding([.top,.bottom],15).padding([.leading,.trailing],30).foregroundColor(.white) .background(Color(.blue)).cornerRadius(10).bold()
                            Spacer()
                        }.padding([.top,.bottom],15)
                        
                    }.onSubmit {
                            print("form submitted")
                    }
            
  
                    if showTable{
                        
                    
                        table(fetchedEmbeddedObject : $fetchedEmbeddedObject);
                    }else{
                        
                        if loadProgressView{
                            ZStack{
                                VStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Results")
                                                .font(.title)
                                                .bold()
                                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                                                .alignmentGuide(.leading) { _ in 0 }
                                            Spacer()
                                        }
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(Color.gray)
                                                .padding(.horizontal, 10)
                                                .offset(y: 30)
                                        )
                                        
                                        VStack{
                                            HStack{
                                                Spacer()
                                                ProgressView()
                                                Spacer()
                                            }
                                            Text("Please wait...").foregroundColor(Color.gray)
                                        }.padding(.vertical,20)
                                    }
                                    .padding(.bottom, 10)                                .background(Color(.white).cornerRadius(20))
                                    Spacer()
                                }
                            }.padding([.leading,.trailing],15).padding(.top,20).onAppear(){
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    loadProgressView = false;
                                    print("table count",self.fetchedEmbeddedObject.events.count)
//                                    noTableData=self.fetchedEmbeddedObject.events.count==0;
                                                        }
                            }
                            
                            
                        }else{
                            if noTableData{
                                ZStack{
                                    VStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Results")
                                                    .font(.title)
                                                    .bold()
                                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                                                    .alignmentGuide(.leading) { _ in 0 }
                                                Spacer()
                                            }
                                            .overlay(
                                                Rectangle()
                                                    .frame(height: 1)
                                                    .foregroundColor(Color.gray)
                                                    .padding(.horizontal, 10)
                                                    .offset(y: 30)
                                            )
                                            
                                            VStack{
                                                HStack{
                                                    
                                                    Text("No result available").foregroundColor(Color.red).padding(.leading,20)
                                                    Spacer()
                                                }
                                            }.padding(.vertical,20)
                                        }
                                        .padding(.bottom, 10)                                .background(Color(.white).cornerRadius(20))
                                        Spacer()
                                    }
                                }.padding([.leading,.trailing],15).padding(.top,20)}
                        }
                        
                    }
                    
                }

                }.sheet(isPresented: $showingSuggestions) {
                    AutocompleteSheet(searchText: $keyword,showingSuggestions: $showingSuggestions,onSelection: {selectedValue in
                        keyword=selectedValue;
                        showingSuggestions=false;
                      getSuggestions=false;
                        currkeywordLength=keyword.count;
//                        noMoreSuggestions=true;
//
                    })
                }
             
        }
            
        }


        
        

    private func getTableparams(){
        let testkeyword=keyword.replacingOccurrences(of: " ", with: "")
        let testlocation=location.replacingOccurrences(of: " ", with: "")

        if (testkeyword.isEmpty || (!autoDetecttoggle && testlocation.isEmpty)){
            noTableData=true;
            print("error coming here")
        }else{

            if autoDetecttoggle{
                var geo_token = "73c9b75a165de1";
                var url = URL(string:"https://ipinfo.io/?token=" + geo_token);

                guard let url = url else {
                    print("Invalid URL")
                    return
                }
                let request = URLRequest(url: url)
                print(url)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error fetching suggestions: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    do {
                        let fetchedApiResponse = try JSONDecoder().decode(ADLocationModel.self, from: data)
                       
        //                        print(fetchedEmbeddedObject);
                        DispatchQueue.main.async {
                                
                            let locArr=fetchedApiResponse.loc.split(separator: ",")
                            if let latStr = String(locArr[0]) as? String, let lngStr = String(locArr[1]) as? String {
                                if let lat = Double(latStr), let lng = Double(lngStr) {
                                    latitude = lat
                                    longitude = lng
                                    print("ADL works", latitude, longitude)
                                    fetchTableData();
                                    
                                } else {
                                    print("Error: Could not convert latitude or longitude to Double")
                                    noTableData=true;
                                }
                            }

                        }
                    } catch {
                        print("Error decoding suggestions: \(error.localizedDescription)")
        //                        if let dataString = String(data: data, encoding: .utf8) {
        //                               print("Received data: \(dataString)")
        //                           }
                        DispatchQueue.main.async {
                            noTableData=true;

                        }
                      
                    }
                }.resume()
                
                
                
                
            }else{
                
                var g_api = "AIzaSyBXO4fUAfXyZhXtIEvZB0xrytVCGLblXO8";
                let loc=location.replacingOccurrences(of: " ", with: "%20")
                var url = URL(string:"https://maps.googleapis.com/maps/api/geocode/json?address=" + loc + "&key=" + g_api);

                guard let url = url else {
                    print("Invalid URL")
                    return
                }
                let request = URLRequest(url: url)
                print(url)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error fetching suggestions: \(error?.localizedDescription ?? "Unknown error")")
                        noTableData=true;

                        return
                    }
                    
                    do {
                        let fetchedApiResponse = try JSONDecoder().decode(GMapLocModel.self, from: data)
                       
        //                        print(fetchedEmbeddedObject);
                        DispatchQueue.main.async {
                                
                            latitude = fetchedApiResponse.results[0].geometry.location.lat
                            longitude = fetchedApiResponse.results[0].geometry.location.lng
                            print("gmap coords",latitude,longitude)
                            fetchTableData();
                        }
                    } catch {
                        print("Error decoding suggestions: \(error.localizedDescription)")
        //                        if let dataString = String(data: data, encoding: .utf8) {
        //                               print("Received data: \(dataString)")
        //                           }
                        DispatchQueue.main.async {
                            noTableData=true;

                        }
                      
                    }
                }.resume()
                
                
                
            }
            
        }
    }

    
    private func fetchTableData() {
        
   
                var keywordParam = "keyword=\(keyword)";
                keywordParam=keywordParam.replacingOccurrences(of: " ", with: "%20");
                let distanceParam = "distance=\(distance)"
                let locationParams = "lat=\(latitude)&long=\(longitude)"
                let categoryParam = "category=\(selectedCategory)"
                let urlString = "https://wbtech571ik-377921.wl.r.appspot.com/getData?" + keywordParam + "&" + distanceParam + "&" + locationParams + "&" + categoryParam
                
                print(urlString)
                guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return
                }
                let request = URLRequest(url: url)
                print(url)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error fetching suggestions: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    do {
                        let fetchedApiResponse = try JSONDecoder().decode(TicketmasterResponse.self, from: data)
                       
//                        print(fetchedEmbeddedObject);
                        DispatchQueue.main.async {

                            self.fetchedEmbeddedObject=fetchedApiResponse._embedded;
//                            print("from c view",self.fetchedEmbeddedObject);

                            noTableData=false;
                            showTable=true;
                            loadProgressView=false;

                        }
                    } catch {
                        print("Error decoding suggestions: \(error.localizedDescription)")
//                        if let dataString = String(data: data, encoding: .utf8) {
//                               print("Received data: \(dataString)")
//                           }
                        DispatchQueue.main.async {
                            //                            self.fetchedEmbeddedObject=fetchedEmbeddedObject=nil;
                            showTable=false;
                            noTableData=true;
                        }
                      
                    }
                }.resume()
            
            
        }
        
        }
        
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView();
        }
    }
    

