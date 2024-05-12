//
//  ProfileView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 11/5/2024.
//

import SwiftUI

struct ProfileView: View {
    
    var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
    var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
    var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)
    
    var body: some View {
        ZStack {
            primaryDarkBlue
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileView()
}
