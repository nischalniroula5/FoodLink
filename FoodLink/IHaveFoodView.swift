//
//  IHaveFoodView.swift
//  FoodLink
//
//  Created by Nischal Niroula on 12/5/2024.
//

import SwiftUI

var primaryGreen = Color(red: 117 / 255.0, green: 185 / 255.0, blue: 110 / 255.0)
var primaryOrange = Color(red: 254 / 255.0, green: 109 / 255.0, blue: 64 / 255.0)
var primaryDarkBlue = Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0)

struct IHaveFoodView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPage = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                primaryDarkBlue.edgesIgnoringSafeArea(.all)
                VStack {
                    if currentPage == 1 {
                        FoodDetailsView(currentPage: $currentPage)
                    } else {
                        PickupDetailsView(currentPage: $currentPage)
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
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FoodDetailsView: View {
    @State private var name: String = ""
    @State private var quantity: String = ""
    @State private var ingredients: String = ""
    @State private var bestBeforeDate = Date()

    
    @Binding var currentPage: Int

    var body: some View {
        VStack {
            HStack {
                Text("Please enter basic details about the food.")
                    .foregroundStyle(primaryGreen)
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
                    
                    DatePicker("", selection: $bestBeforeDate, in:Date()..., displayedComponents: .date)
                    .labelsHidden()
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .colorScheme(.dark)
                    .accentColor(primaryGreen)
                    
                }
                
                Spacer()  // Pushes all content to the top
            }
            .padding(.top)
            
            HStack {
                Spacer()
                Button("Next") {
                                currentPage = 2  // Logic to change page or perform an action
                            }
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color(red: 24 / 255.0, green: 30 / 255.0, blue: 42 / 255.0))  // Text color
                            .frame(width: 100, height: 60)  // Custom width and height
                            .background(Color.green)  // Background color
                            .cornerRadius(7)
                            .padding(.horizontal)
                
                
            }
            .padding(.bottom)
            
            Text("Page: 1/2")
                .foregroundColor(Color.gray)
        }
        .padding()
    }
}

struct PickupDetailsView: View {
    @Binding var currentPage: Int

    var body: some View {
        VStack {
            Text("Almost Done. Now let's take a picture and enter pickup details.")
                .padding()
            Form {
                TextField("Pickup Location", text: .constant("37 Blackburn Street, Hawthorn, 3000"))
                DatePicker("Pickup Before:", selection: .constant(Date()), displayedComponents: [.date, .hourAndMinute])
                TextField("Any Notes", text: .constant("Please pickup before the store closes. You can eat the food now or keep it in fridge until tomorrow"))
                Button("Back") {
                    currentPage = 1
                }
                Button("Share Food") {
                    // Code to handle sharing the food
                }
                .buttonStyle(PrimaryButtonStyle(bgColor: Color.green))
            }
        }
        .padding()
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
