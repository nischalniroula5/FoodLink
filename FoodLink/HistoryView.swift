//
//  HistoryView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 11/5/2024.
//

import SwiftUI

struct HistoryView: View {
    var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
    var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
    var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)
    
    @State private var selectedMainSegment = "Given"
    @State private var selectedSubSegment = "Online"
    
    let givenOptions = ["Online", "Claimed", "Expired", "Picked Up"]
    let gottenOptions = ["Claimed", "Expired", "Picked Up"]
    
    var subSegmentOptions: [String] {
        // Return the correct options based on the selected main segment
        selectedMainSegment == "Given" ? givenOptions : gottenOptions
    }
    
    
    init() {
        // Change background color
        UISegmentedControl.appearance().backgroundColor = UIColor(primaryDarkBlue)
        
        // Change selected segment text color
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(primaryGreen)
        
        // Change normal state text color
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(primaryOrange)], for: .normal)
        
        // Change selected state text color
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    
    var body: some View {
        ZStack {
            primaryDarkBlue
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                // Main segment control
                            Picker("Options", selection: $selectedMainSegment) {
                                Text("Given").tag("Given")
                                Text("Gotten").tag("Gotten")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .onChange(of: selectedMainSegment) { newValue in
                                // Reset the subsegment to the first option of the new selection
                                selectedSubSegment = subSegmentOptions.first ?? "Claimed"
                            }
                
                // Sub-segment control
                            Picker("Options", selection: $selectedSubSegment) {
                                ForEach(subSegmentOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding([.leading, .trailing, .bottom])
                
                Spacer()
                /*
                // List of items
                List {
                    HistoryItem()
                    HistoryItem()
                    HistoryItem()
                }
                */
            }
            .navigationBarTitle("History", displayMode: .inline)
        }
    }
}

// History item view
struct HistoryItem: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("foodImage") // Replace with actual image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text("Salmon OG")
                        .font(.headline)
                    Text("1 Bowl")
                        .font(.subheadline)
                    Text("15:06  10-04-2024")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    Text("Expired")
                        .foregroundColor(.red)
                        .font(.caption)
                    Spacer()
                }
            }
            
            // Buttons
            HStack {
                Button("Cancel Pickup") {
                    // handle cancel
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(8)
                
                Button("Picked Up") {
                    // handle picked up
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.primary.colorInvert())
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
