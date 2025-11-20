//
//  FirebaseAuthService.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    private init() {}
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    // Kullanıcı girişi
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            completion(error)
        }
    }
    
    // Current user id
    func currentUserId() -> String? {
        return auth.currentUser?.uid
    }
    
    // Firestore'dan username çekme
    func fetchUsername(completion: @escaping (String?) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(nil)
            return
        }
        
               db.collection("users").document(uid).getDocument { snapshot, _ in
                   let username = snapshot?.get("username") as? String
                   completion(username)
               }
        
    }
}
