//
//  LoginView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 11/5/2024.
//

import SwiftUI

struct LoginView: View {
    var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
    var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
    var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)
    
    @State private var showingHomeScreen = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("background") // Make sure to add the correct image in your assets
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // Contents
                VStack {
                    Spacer()
                    
                    HStack {
                        Text("FOOD FOR EVERY ONE")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(primaryGreen)
                            .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        
                        Spacer()
                    }

                    Spacer()
                    
                    Button(action: {
                        self.showingHomeScreen = true
                    }) {
                        HStack {
                            Text("Sign In With Apple")
                                .fontWeight(.semibold)
                                .padding(.leading, 20)
                                .font(.system(size: 24))
                            Spacer()
                            Image(systemName: "applelogo")
                                .padding(.trailing, 20)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .padding(.vertical, 10)
                        .foregroundColor(primaryDarkBlue)
                        .background(primaryOrange)
                        .cornerRadius(7)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)

                    // Sign in with Google
                    Button(action: {
                        self.showingHomeScreen = true
                    }) {
                        HStack {
                            
                            Text("Sign In With Google")
                                .fontWeight(.semibold)
                                .padding(.leading, 20)
                                .font(.system(size: 24))
                            Spacer()
                            Image("googlelogo")
                                .padding(.trailing, 20)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .padding(.vertical, 10)
                        .foregroundColor(primaryDarkBlue)
                        .background(primaryOrange)
                        .cornerRadius(7)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 80)

                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingHomeScreen) {
                MainView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


#Preview {
    LoginView()
}
