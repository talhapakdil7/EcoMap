import Foundation
import FirebaseStorage
import UIKit

final class StorageService {
    static let shared = StorageService()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            completion(nil)
            return
        }
        
        let id = UUID().uuidString
        let imageRef = storage.child("images/\(id).jpg")
        
        imageRef.putData(data, metadata: nil) { _, error in
            if error != nil {
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
}

