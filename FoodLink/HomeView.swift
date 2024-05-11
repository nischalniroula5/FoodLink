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
    
    var body: some View {
        ZStack {
            primaryDarkBlue
            
            VStack {
                Image("homeImage")
                
                    .padding(.top, 120)
                Spacer()
                
                
                HStack {
                    Text("Impact in Number")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(.white)
                    
                    Spacer()
                }.padding(.horizontal)
                    .padding(.bottom, 10)
                
                HStack() {
                    Text("Total Food Shared:")
                        .fontWeight(.semibold)
                        .foregroundColor(primaryGreen)
                    Spacer()
                    Text("230")
                        .fontWeight(.bold)
                        .foregroundColor(primaryGreen)
                }
                .padding(.horizontal)
                
                HStack() {
                    Text("Total People Fed:")
                        .fontWeight(.semibold)
                        .foregroundColor(primaryGreen)
                    Spacer()
                    Text("230")
                        .fontWeight(.bold)
                        .foregroundColor(primaryGreen)
                }
                .padding(.horizontal)
                
                Spacer()
                // Buttons
                VStack {
                    Button(action: {
                        //Action
                    }) {
                        HStack {
                            
                            Text("I Have Food")
                                .fontWeight(.semibold)
                                .padding(.leading, 20)
                                .font(.system(size: 24))
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .padding(.vertical, 10)
                        .foregroundColor(primaryDarkBlue)
                        .background(primaryGreen)
                        .cornerRadius(7)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    
                    Button(action: {
                        //Action
                    }) {
                        HStack {
                            
                            Text("I Need Food")
                                .fontWeight(.semibold)
                                .padding(.leading, 20)
                                .font(.system(size: 24))
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .padding(.vertical, 10)
                        .foregroundColor(primaryDarkBlue)
                        .background(primaryOrange)
                        .cornerRadius(7)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 120)
                
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
