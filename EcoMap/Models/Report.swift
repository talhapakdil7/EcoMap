//
//  Report.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//


import Foundation
import CoreLocation
import FirebaseFirestore

struct Report {
    let id: String
    let userId: String
    let username: String
    let imageUrl: String
    let description: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
}
