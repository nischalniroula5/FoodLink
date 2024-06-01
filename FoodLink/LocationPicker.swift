import SwiftUI
import MapKit

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct LocationPicker: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var selectedAddress: String?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var annotations: [IdentifiableCoordinate] = []
    @State private var searchResults: [MKMapItem] = []
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText, searchAction: searchLocation)
            
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: annotations) { location in
                MapPin(coordinate: location.coordinate)
            }
            .edgesIgnoringSafeArea(.all)
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        let newLocation = region.center
                        selectedLocation = newLocation
                        annotations = [IdentifiableCoordinate(coordinate: newLocation)]
                        reverseGeocodeLocation(newLocation)
                    }
            )
            
            List(searchResults, id: \.self) { item in
                Button(action: {
                    if let coordinate = item.placemark.location?.coordinate {
                        region.center = coordinate
                        selectedLocation = coordinate
                        annotations = [IdentifiableCoordinate(coordinate: coordinate)]
                        selectedAddress = item.placemark.name ?? "Unknown location"
                    }
                }) {
                    Text(item.name ?? "Unknown")
                }
            }
            .background(Color.white)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Select Location")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            if let location = locationManager.location {
                region.center = location
                selectedLocation = location
                annotations = [IdentifiableCoordinate(coordinate: location)]
                selectedAddress = locationManager.address
            }
        }
        .onReceive(locationManager.$location) { newLocation in
            if let newLocation = newLocation {
                region.center = newLocation
                selectedLocation = newLocation
                annotations = [IdentifiableCoordinate(coordinate: newLocation)]
                selectedAddress = locationManager.address
            }
        }
    }
    
    private func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                searchResults = response.mapItems
            }
        }
    }
    
    private func reverseGeocodeLocation(_ location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let placemark = placemarks?.first {
                selectedAddress = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search for a location", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                searchAction()
            }) {
                Text("Search")
            }
            .padding()
        }
        .background(Color.white)
    }
}
