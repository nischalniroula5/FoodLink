import SwiftUI
import CoreLocation
import Firebase
import FirebaseFirestore

struct INeedFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locationManager = LocationManager()
    
    @State private var foodItems: [FoodItem] = []
    @State private var searchText: String = ""
    @State private var filteredItems: [FoodItem] = []

    var body: some View {
        NavigationView {
            ZStack {
                primaryDarkBlue.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("customBackButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundColor(primaryOrange)
                        }
                        Spacer()
                        Text("Get Food")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(primaryOrange)
                        Spacer()
                        Spacer() // To balance the space
                    }
                    .padding()

                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(filteredItems) { item in
                                FoodItemView(item: item, userLocation: locationManager.location)
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear(perform: loadFoodItems)
        }
    }
    
    func filterFoodItems() {
        if searchText.isEmpty {
            filteredItems = foodItems
        } else {
            filteredItems = foodItems.filter { $0.name.contains(searchText) }
        }
    }
    
    func loadFoodItems() {
        let db = Firestore.firestore()
        db.collection("foodDetails").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            self.foodItems = documents.map { doc -> FoodItem in
                let data = doc.data()
                return FoodItem(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    quantity: data["quantity"] as? String ?? "",
                    ingredients: data["ingredients"] as? String ?? "",
                    bestBeforeDate: (data["bestBeforeDate"] as? Timestamp)?.dateValue() ?? Date(),
                    notes: data["notes"] as? String ?? "",
                    pickupLocation: data["pickupLocation"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0),
                    pickupBefore: (data["pickupBefore"] as? Timestamp)?.dateValue() ?? Date(),
                    imageUrl: data["imageURL"] as? String ?? ""
                )
            }
            self.filteredItems = self.foodItems
        }
    }
}

struct FoodItemView: View {
    let item: FoodItem
    let userLocation: CLLocationCoordinate2D?
    
    @State private var distance: Double?
    @State private var address: String = "Loading address..."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Text(item.quantity)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("\(item.bestBeforeDate, formatter: DateFormatter.shortDateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 5)

            if let url = URL(string: item.imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                        .frame(height: 120)
                }
            }
            HStack {
                Text("Pickup Before: ")
                    .font(.headline)
                    .foregroundColor(primaryOrange)
                Text("\(item.pickupBefore, formatter: DateFormatter.fullDateFormatter)")
                    .foregroundColor(.white)
            }
            
            if let distance = distance {
                HStack {
                    Text("Distance: ")
                        .foregroundColor(primaryOrange)
                        .font(.headline)
                    Text("\(String(format: "%.2f", distance)) km")
                        .foregroundColor(.white)
                }
            }


            Text("Ingredients:")
                .font(.headline)
                .foregroundColor(primaryOrange)
            Text(item.ingredients)
                .foregroundColor(.white)

            Text("Notes:")
                .font(.headline)
                .foregroundColor(primaryOrange)
            Text(item.notes)
                .foregroundColor(.white)
                        
            HStack {
                Spacer()
                Button(action: {
                    // Action for claim button
                }) {
                    Text("Claim")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(primaryDarkBlue)
                        .frame(width: 100, height: 40)
                        .background(primaryOrange)
                        .cornerRadius(7)
            }
            }
        }
        .padding()
        .background(Color(red: 44 / 255, green: 62 / 255, blue: 80 / 255))
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            geocodeAddress()
            calculateDistance()
        }
    }
    
    func geocodeAddress() {
        let location = CLLocation(latitude: item.pickupLocation.latitude, longitude: item.pickupLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.address = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            } else {
                self.address = "Address not found"
            }
        }
    }
    
    func calculateDistance() {
        if let userLocation = userLocation {
            let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let pickupLoc = CLLocation(latitude: item.pickupLocation.latitude, longitude: item.pickupLocation.longitude)
            self.distance = userLoc.distance(from: pickupLoc) / 1000 // Convert to kilometers
        }
    }
}

struct FoodItem: Identifiable {
    var id: String
    var name: String
    var quantity: String
    var ingredients: String
    var bestBeforeDate: Date
    var notes: String
    var pickupLocation: GeoPoint
    var pickupBefore: Date
    var imageUrl: String
}

extension DateFormatter {
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct INeedFoodView_Previews: PreviewProvider {
    static var previews: some View {
        INeedFoodView()
    }
}
