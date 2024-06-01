//
//  FoodLinkApp.swift
//  FoodLink
//
//  Created by Nischal Niroula on 11/5/2024.
//
import SwiftUI
import FirebaseCore

@main
struct FoodLinkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
