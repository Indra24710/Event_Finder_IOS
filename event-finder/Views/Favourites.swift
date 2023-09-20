//
//  Favourites.swift
//  event-finder
//
//  Created by Indra Kumar on 5/1/23.
//

import SwiftUI

struct Favourites: View {
    @State var favArray:[[String]]=[];
    @State private var showToast=false;
    @State private var toastMessage="";

    
    
    var body: some View {
        VStack{
            if (favArray.isEmpty){
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text("No favorites found").font(.title3).foregroundColor(Color.red)
                        Spacer()
                        
                    }
                    Spacer()}
            }else{
                ZStack{
                    Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Favorites")
                                .font(.title)
                                .bold()
                                .padding(10)
                                .alignmentGuide(.leading) { _ in 0 }
                            Spacer()
                        }
                        
                        
                        
                        
                        
                        ScrollView{    List($favArray, id: \.self){event in
                            
                            
                            HStack{
                                // Represents row elements
                                Text(event[0].wrappedValue)
                                Spacer()
                                Text(event[1].wrappedValue)
                                Spacer()
                                Text(event[2].wrappedValue)
                                Spacer()
                                
                                Text(event[3].wrappedValue)
                            }.swipeActions(edge:.trailing,allowsFullSwipe: false){
                                Button(action: {
                                    // Delete the item at the specified index
                                    deleteItem(id:event[4].wrappedValue)
                                    toastMessage="Removed from favorites"
                                    showToast=true;
                                }) {
                                    Text("Delete").font(.title3)                                                    }
                                .tint(.red)
                            }
                            
                            
                            
                        }.listStyle(PlainListStyle()).frame(maxWidth: .infinity).frame(height:250).font(.subheadline).cornerRadius(20)
                        }
                        
                        
                    }.padding(.horizontal,5).padding([.leading,.trailing],10).padding(.top,15)
                    
                    
                    
                    
                }
            }}.onAppear(){
                loadFavtable();
            } .overlay(
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
        
        
    
//
//func deleteItem(index:String){
//    print(Int(index),type(of: Int(index)))
//    var index=Int(index)
//    if let indVal = index as? Int{
//
//        print("index",indVal)
//
//        if let existingData = getLS(forKey:"favouriteElements"){
//            print("prefix",Array(existingData.prefix(indVal)))
//            print("suffix",Array(existingData.suffix(from:indVal+1)))
//            let newData = Array(existingData.prefix(indVal)) + Array(existingData.suffix(from:indVal+1))
//            saveLS(newData, forKey: "favouriteElements")
//            loadFavtable()
//            print(favArray)
//        }
//
//    }
//
//
//
//
//
//    }
    func deleteItem(id:String){
        
//        print(Int(index),type(of: Int(index)))
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
        
        saveLS(newjsonArray, forKey: "favouriteElements");
        loadFavtable();
       
        
        
        
        
        
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
    func loadFavtable(){
        favArray=[];
        if let existingJsonArray = getLS(forKey: "favouriteElements") {
            var count=0
            for i in existingJsonArray {
                      if var i = i as? [Any] {
//                          i = i + [String(count)]
//                          count += 1
                          var tempArr: [String] = []

                          for j in i {
                              if let j = j as? String {
                                  tempArr.append(j)
                              }
                          }

                          favArray.append(tempArr)
                      }
                  }
            
           } else {
               print("Error: Unable to load data from local storage.")
           }
        
    }
    func saveLS(_ jsonArray: [Any], forKey key: String) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            UserDefaults.standard.set(jsonData, forKey: key)
        } catch {
            print("Error: Unable to serialize JSON data.")
        }
    }
    
}
struct Favourites_Previews: PreviewProvider {
    static var previews: some View {
        Favourites()
    }
}
