//
//  LocationSearchView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 12/5/2024.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @State private var query: String = ""
    @State private var places: [MKMapItem] = []
    
    var body: some View {
        VStack {
            TextField("Enter location", text: $query, onCommit: {
                search()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .foregroundColor(.white)
            .background(Color.gray)  // Appropriate backgroundMel
            
            List(places, id: \.self) { place in
                Text(place.name ?? "Unknown")
            }
        }
        .padding()
        .background(Color.black)  // Assuming a dark theme
    }
    
    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            places = response?.mapItems ?? []
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView()
    }
}
