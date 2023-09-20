//
//  SplashScreen.swift
//  event-finder
//
//  Created by Indra Kumar on 5/4/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack{
            
            Spacer()
            HStack{
                Spacer()
                Image("splash")
                    .resizable()
                     .scaledToFit()
                     .frame(maxWidth: 300, maxHeight: 150)
                Spacer()
            }
            Spacer()
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
