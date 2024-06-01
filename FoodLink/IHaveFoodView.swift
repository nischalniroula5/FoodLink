import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseStorage

var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)





struct IHaveFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPage = 1

    // Define the state properties
    @State private var name: String = ""
    @State private var quantity: String = ""
    @State private var ingredients: String = ""
    @State private var bestBeforeDate = Date()
    @State private var pickupLocation: CLLocationCoordinate2D?
    @State private var pickupAddress: String?
    @State private var notes: String = ""
    @State private var pickupBefore = Date()
    @State private var image: UIImage?


    var body: some View {
        NavigationView {
            ZStack {
                primaryDarkBlue.edgesIgnoringSafeArea(.all)
                VStack {
                    if currentPage == 1 {
                        FoodDetailsView(
                            name: $name,
                            quantity: $quantity,
                            ingredients: $ingredients,
                            bestBeforeDate: $bestBeforeDate,
                            currentPage: $currentPage
                        )
                    } else {
                        PickupDetailsView(
                            name: $name,
                            quantity: $quantity,
                            ingredients: $ingredients,
                            bestBeforeDate: $bestBeforeDate,
                            pickupLocation: $pickupLocation,
                            pickupAddress: $pickupAddress,
                            notes: $notes,
                            pickupBefore: $pickupBefore,
                            image: $image,
                            currentPage: $currentPage
                        )
                    }
                }
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("customBackButton")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(currentPage == 1 ? "Share Food Details" : "Pickup Details")
                        .foregroundColor(primaryGreen)
                        .fontWeight(.bold)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FoodDetailsView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Binding var name: String
    @Binding var quantity: String
    @Binding var ingredients: String
    @Binding var bestBeforeDate: Date
    @Binding var currentPage: Int

    func validateFoodDetails() -> Bool {
        return !name.isEmpty && !quantity.isEmpty && !ingredients.isEmpty
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Please enter basic details about the food.")
                    .foregroundColor(primaryGreen)
                Spacer()
            }
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Text("Name:")
                    .foregroundColor(.white)
                CustomTextFieldView(text: $name, placeholder: "Enter name")
                
                Text("Quantity:")
                    .foregroundColor(.white)
                CustomTextFieldView(text: $quantity, placeholder: "Enter quantity")
                
                HStack {
                    Text("Ingredients:")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Separate them by comma (,)")
                        .foregroundColor(.gray)
                }
                CustomTextFieldView(text: $ingredients, placeholder: "Separate them by comma (,)")
                
                HStack {
                    Text("Best Before:")
                        .foregroundColor(.white)
                    Spacer()
                    DatePicker("", selection: $bestBeforeDate, in: Date()..., displayedComponents: .date)
                        .labelsHidden()
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .colorScheme(.dark)
                        .accentColor(primaryGreen)
                }
                Spacer()
            }
            .padding(.top)
            
            HStack {
                Spacer()
                Button("Next") {
                    if validateFoodDetails() {
                        currentPage = 2
                    } else {
                        alertMessage = "Please fill in all the details"
                        showAlert = true
                    }
                }
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(primaryDarkBlue)
                .frame(width: 100, height: 60)
                .background(primaryGreen)
                .cornerRadius(7)
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Incomplete Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }


            }
            .padding(.bottom)
            
            Text("Page: 1/2")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct PickupDetailsView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Binding var name: String
    @Binding var quantity: String
    @Binding var ingredients: String
    @Binding var bestBeforeDate: Date
    @Binding var pickupLocation: CLLocationCoordinate2D?
    @Binding var pickupAddress: String?
    @Binding var notes: String
    @Binding var pickupBefore: Date
    @Binding var image: UIImage?
    @Binding var currentPage: Int

    @State private var showingImagePicker = false
    @State private var showingLocationPicker = false

    func validatePickupDetails() -> Bool {
        return pickupLocation != nil && !notes.isEmpty && image != nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Almost Done. Now let's take a picture and enter pickup details.")
                    .foregroundColor(primaryGreen)
                Spacer()
            }
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Text("Pickup Location:")
                    .foregroundColor(.white)
                Button(action: {
                    showingLocationPicker = true
                }) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        if let pickupAddress = pickupAddress {
                            Text(pickupAddress)
                                .foregroundColor(.white)
                        } else {
                            Text("Select Location")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color(red: 44 / 255, green: 62 / 255, blue: 80 / 255))
                    .cornerRadius(10)
                }
                
                HStack {
                    Text("Pickup Before:")
                        .foregroundColor(.white)
                    Spacer()
                    DatePicker("", selection: $pickupBefore, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .colorScheme(.dark)
                        .accentColor(primaryGreen)
                        .padding()
                }
                
                Text("Any Notes:")
                    .foregroundColor(.white)
                CustomTextFieldView(text: $notes, placeholder: "Enter notes")
                
                HStack {
                    Text("Add Picture:")
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Image("addPicture")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                }
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                Spacer()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $image)
            }
            .sheet(isPresented: $showingLocationPicker) {
                LocationPicker(selectedLocation: $pickupLocation, selectedAddress: $pickupAddress)
            }
            .padding(.top)
            
            HStack {
                Button("Back") {
                    currentPage = 1
                }
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(primaryDarkBlue)
                .frame(width: 100, height: 60)
                .background(primaryOrange)
                .cornerRadius(7)
                .padding(.horizontal)
                
                Spacer()
                Button("Next") {
                    if validatePickupDetails() {
                        if let image = image {
                            uploadImage(image) { result in
                                switch result {
                                case .success(let url):
                                    print("Image uploaded successfully. URL: \(url)")
                                    saveToFirebase(imageURL: url)
                                case .failure(let error):
                                    print("Error uploading image: \(error)")
                                }
                            }
                        } else {
                            saveToFirebase(imageURL: nil)
                        }
                    } else {
                        alertMessage = "Please fill in all the details"
                        showAlert = true
                    }
                }
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(primaryDarkBlue)
                .frame(width: 100, height: 60)
                .background(primaryGreen)
                .cornerRadius(7)
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Incomplete Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }


            }
            .padding(.bottom)
            
            Text("Page: 2/2")
                .foregroundColor(.gray)
        }
        .padding()
    }
    


    func saveToFirebase(imageURL: String?) {
        let db = Firestore.firestore()
        let foodDetails: [String: Any] = [
            "name": name,
            "quantity": quantity,
            "ingredients": ingredients,
            "bestBeforeDate": Timestamp(date: bestBeforeDate),
            "pickupBefore": Timestamp(date: pickupBefore),
            "pickupLocation": pickupLocation != nil ? GeoPoint(latitude: pickupLocation!.latitude, longitude: pickupLocation!.longitude) : NSNull(),
            "pickupAddress": pickupAddress ?? "",
            "notes": notes,
            "imageURL": imageURL ?? ""
        ]

        db.collection("foodDetails").addDocument(data: foodDetails) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }


    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // Create a storage reference
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a unique name for the image
        let imageName = UUID().uuidString
        let imagesRef = storageRef.child("images/\(imageName).jpg")

        // Convert the image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Error converting image", code: -1, userInfo: nil)))
            return
        }

        // Upload the image data
        let uploadTask = imagesRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Get the download URL
            imagesRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                } else {
                    completion(.failure(NSError(domain: "Error getting download URL", code: -1, userInfo: nil)))
                }
            }
        }

        // Monitor upload progress
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Upload is \(percentComplete)% complete")
        }
    }
}

struct CustomTextFieldView: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(red: 44 / 255, green: 62 / 255, blue: 80 / 255))
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.system(size: 18))
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 2)
    }
}

struct IHaveFoodView_Previews: PreviewProvider {
    static var previews: some View {
        IHaveFoodView()
    }
}
