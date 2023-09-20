//
//  AppDelegate.swift
//  event-finder
//
//  Created by Indra Kumar on 5/2/23.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBXO4fUAfXyZhXtIEvZB0xrytVCGLblXO8")
        return true
    }
}
