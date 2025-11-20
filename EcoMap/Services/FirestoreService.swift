//
//  FirestoreService.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//

import Foundation
import FirebaseFirestore

final class FirestoreService {
    static let shared = FirestoreService()
    private init() {}
    
    
    private let db = Firestore.firestore()
    
    // Rapor ekleme (sonra dolduracağız)
       func addReport(_ data: [String: Any], completion: @escaping (Error?) -> Void) {
           db.collection("reports").addDocument(data: data) { error in
               completion(error)
           }
       }

       // Raporları dinleme (sonra dolduracağız)
       func listenReports(completion: @escaping ([Report]) -> Void) {
           db.collection("reports")
               .order(by: "createdAt", descending: true)
               .addSnapshotListener { snapshot, error in
                   
                   // Şimdilik boş bırakıyoruz
                   completion([])
               }
       }
}
