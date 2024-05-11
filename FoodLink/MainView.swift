//
//  MainView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 11/5/2024.
//
import SwiftUI

struct MainView: View {
    var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
    var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
    var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill") // Example icon
                        Text("Home")
                    }
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "clock.fill") // Example icon
                        Text("History")
                    }
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill") // Example icon
                        Text("Profile")
                    }
                }
                .tag(2)
        }
        .accentColor(primaryOrange) // Color for selected tab item
        .background(primaryDarkBlue.edgesIgnoringSafeArea(.all)) // Set background color here
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
