//
//  HomeView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 11/5/2024.
//

import SwiftUI

struct HomeView: View {
    var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
    var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
    var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)
    
    @State private var showIHaveFoodView = false
    @State private var showINeedFoodView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                primaryDarkBlue.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("homeImage")
                        .padding()
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Impact in Number")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        
                        DetailView(label: "Total Food Shared:", value: "230", color: primaryGreen)
                        DetailView(label: "Total People Fed:", value: "230", color: primaryGreen)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button("I Have Food") {
                            showIHaveFoodView = true
                        }
                        .buttonStyle(PrimaryButtonStyle(bgColor: primaryGreen))
                        .fullScreenCover(isPresented: $showIHaveFoodView) {
                            IHaveFoodView()
                        }
                        
                        Button("I Need Food") {
                            showINeedFoodView = true
                        }
                        .buttonStyle(PrimaryButtonStyle(bgColor: primaryOrange))
                        .fullScreenCover(isPresented: $showINeedFoodView) {
                            INeedFoodView()
                        }
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

// Helper view for details
struct DetailView: View {
    var label: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
                .foregroundColor(color)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding(.horizontal)
    }
}

// Button styling
struct PrimaryButtonStyle: ButtonStyle {
    var bgColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .padding(.leading, 20)
            .font(.system(size: 24))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .padding(.vertical, 10)
            .foregroundColor(Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0))
            .background(bgColor)
            .cornerRadius(7)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
