//
//  UploadViewModel.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//

import Foundation
import UIKit
import FirebaseFirestore

final class UploadViewModel {
    
    var onUploadSuccess: (() -> Void)?
    var onUploadError: ((String) -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?
    
    func upload(image: UIImage,
                description: String,
                latitude: Double,
                longitude: Double) {
        
        // Yükleniyor bilgisi
        isLoadingChanged?(true)
        
        guard let userId = FirebaseAuthService.shared.currentUserId() else {
            isLoadingChanged?(false)
            onUploadError?("Kullanıcı oturumu bulunamadı.")
            return
        }
        
        // Önce username çekelim
        FirebaseAuthService.shared.fetchUsername { [weak self] username in
            guard let self = self else { return }
            
            guard let username = username else {
                self.isLoadingChanged?(false)
                self.onUploadError?("Kullanıcı adı bulunamadı.")
                return
            }
            
            // 1) Fotoğrafı Storage'a yükle
            StorageService.shared.uploadImage(image) { urlString in
                guard let imageUrl = urlString else {
                    self.isLoadingChanged?(false)
                    self.onUploadError?("Görsel yüklenemedi.")
                    return
                }
                
                // 2) Firestore'a rapor ekle
                let data: [String: Any] = [
                    "userId": userId,
                    "username": username,
                    "imageUrl": imageUrl,
                    "description": description,
                    "latitude": latitude,
                    "longitude": longitude,
                    "createdAt": Timestamp()
                ]
                
                FirestoreService.shared.addReport(data) { error in
                    self.isLoadingChanged?(false)
                    
                    if let error = error {
                        self.onUploadError?(error.localizedDescription)
                    } else {
                        self.onUploadSuccess?()
                    }
                }
            }
        }
    }
}
