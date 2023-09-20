//
//  AutocompleteSheet.swift
//  event-finder
//
//  Created by Indra Kumar on 4/13/23.
//

import SwiftUI
import Foundation

struct AutocompleteSheet: View {
    @Binding var searchText: String;
    @Binding var showingSuggestions:Bool;
    @State private var suggestions: [String] = []

    

    

    
    private func fetchKeywordSuggestions(searchText: String) {
            var lowersearchText=searchText.lowercased();
        lowersearchText=lowersearchText.replacingOccurrences(of:" ", with: "%20")
        guard let url = URL(string: "https://wbtech571ik-377921.wl.r.appspot.com/getkeywordsuggestions?keyword=" + lowersearchText)
        else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)
            print(url,searchText)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching suggestions: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let fetchedApiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                    let fetchedAttractionsObjects = fetchedApiResponse._embedded.attractions
                    let attractionsNames = fetchedAttractionsObjects.map { $0.name }
                    
                    DispatchQueue.main.async {
                        self.suggestions = attractionsNames.filter { $0.lowercased().contains(searchText.lowercased()) }
                    }
                } catch {
                    print("Error decoding suggestions: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.suggestions = []
                        showingSuggestions=false;
                    }
                }
            }.resume()
    }
    var onSelection: ((String) -> Void)? // Closure property
    
    
    init(searchText: Binding<String>, showingSuggestions: Binding<Bool>, onSelection: ((String) -> Void)?) {
        _searchText = searchText
        _showingSuggestions = showingSuggestions
        self.onSelection = onSelection
    }
    
    
    var body: some View {
        VStack {
            if self.suggestions.count==0{
                
                Spacer()
                HStack{
                    Spacer()
                    ProgressView()
                    
                    Spacer()
                }
                Text("loading...").foregroundColor(Color.gray)
                Spacer()
                
            }else{
                Text("Suggestions").font(.largeTitle).bold()
                Form {
                    List(suggestions, id: \.self) { suggestion in
                        Button(action: {
                            onSelection?(suggestion);
                            showingSuggestions=false;
                        }) {
                            Text(suggestion).foregroundColor(.black)
                        }
                    }
                }.listStyle(PlainListStyle())
                
                
            }
        }
        .padding(.top, 20)
        .onAppear {
            fetchKeywordSuggestions(searchText: searchText)
        }
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                fetchKeywordSuggestions(searchText: newValue)
            } else {
                self.suggestions = []
            }
        }
    }
}

//struct AutocompleteSheet_Previews: PreviewProvider {
//    @State static private var searchText="";
//    @State static private var showingSuggestions=false;
//    
//    static var previews: some View {
//        AutocompleteSheet(searchText:$searchText,showingSuggestions:$showingSuggestions);
//    }
//}
