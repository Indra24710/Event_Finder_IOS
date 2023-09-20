//
//  testUI.swift
//  event-finder
//
//  Created by Indra Kumar on 4/29/23.
//

import SwiftUI

struct testUI: View {
    var body: some View {
        VStack{
            VStack{
                Spacer()
                HStack{
                    Text("Hello, World!")
                    Text("Hello, World!")
                }.padding([.leading,.trailing],30)
                HStack{
                    Text("Hello, World!")
                    Text("Hello, World!")
                }.padding([.leading,.trailing],30)
                HStack{
                    Text("Hello, World!")

                }.padding([.leading,.trailing],30)
           
        
                Spacer()
            }.background(Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 0.90).cornerRadius(20))
            .foregroundColor(Color.white)
                .padding([.leading,.trailing],50).padding([.top,.bottom],100).cornerRadius(2000000) // <-- Add this line to round the corners

               
            
            
        }

    }
}

struct testUI_Previews: PreviewProvider {
    static var previews: some View {
        testUI()
    }
}
