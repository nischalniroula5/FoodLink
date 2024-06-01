//
//  FoodDetails.swift
//  FoodLink
//
//  Created by Nischal Niroula on 18/5/2024.
//
import Foundation
import FirebaseFirestore

struct FoodDetails: Codable {
    var name: String
    var quantity: String
    var ingredients: String
    var bestBeforeDate: Date
    var pickupLocation: String
    var pickupBefore: Date
    var imageUrl: String?
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "quantity": quantity,
            "ingredients": ingredients,
            "bestBeforeDate": Timestamp(date: bestBeforeDate),
            "pickupLocation": pickupLocation,
            "pickupBefore": Timestamp(date: pickupBefore),
            "imageUrl": imageUrl ?? ""
        ]
    }
}
