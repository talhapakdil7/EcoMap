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
    // Kullanıcı oturumu var mı?
    func isLoggedIn() -> Bool {
        return auth.currentUser != nil
    }

    
    // Current user id
    func currentUserId() -> String? {
        return auth.currentUser?.uid
    }
    
    // Firestore'dan username çekme
    func fetchUsername(completion: @escaping (String?) -> Void) {
        guard let user = auth.currentUser else {
            completion(nil)
            return
        }
        
        let uid = user.uid
        let email = user.email
        
        db.collection("users").document(uid).getDocument { snapshot, _ in
            if let username = snapshot?.get("username") as? String {
                // Firestore'da username alanı varsa onu kullan
                completion(username)
            } else {
                // Firestore'da doküman yoksa ya da username alanı yoksa,
                // fallback: email'i username gibi kullan
                completion(email)
            }
        }
    }
    // Şu anki kullanıcının email'i
    func currentUserEmail() -> String? {
        return auth.currentUser?.email
    }
    
    // Çıkış yapma
    func signOut() throws {
        try auth.signOut()
    }
    // Yeni kullanıcı oluşturma (Sign Up)
    func createUser(email: String,
                    password: String,
                    username: String,
                    completion: @escaping (Error?) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(NSError(domain: "uid_error", code: -1))
                return
            }
            
            // Firestore'da users/{uid} dokümanı açıyoruz
            let userData: [String: Any] = [
                "username": username,
                "email": email
            ]
            
            self.db.collection("users").document(uid).setData(userData) { error in
                completion(error)
            }
        }
    }



}
