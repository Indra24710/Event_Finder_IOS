//
//  event_finderApp.swift
//  event-finder
//
//  Created by Indra Kumar on 4/13/23.
//

import SwiftUI

@main
struct event_finderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var splash=true;
    var body: some Scene {
        WindowGroup {
            VStack{
                if splash{
                    SplashScreen()
                }
                else{
                    ContentView()
                    
                }
            }.onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation {
                                    splash = false
                                }
                            }
            }
        }
    }
}
