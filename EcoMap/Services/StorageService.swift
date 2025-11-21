import Foundation
import FirebaseStorage
import UIKit

final class StorageService {
    static let shared = StorageService() // statıc olarak olusturduk storage servisi
    
    private init() {} // initialize edilemez dedık
    
    private let storage = Storage.storage().reference()
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        
        //fotografı dataya cevir
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            completion(nil)
            return
        }
        
        //uuid ata fotografa
        
        let id = UUID().uuidString
        //imagesın altına ekle foto idsini
        
        let imageRef = storage.child("images/\(id).jpg")
        
        //bu idye datayı sıkıştır
        
        imageRef.putData(data, metadata: nil) { _, error in
            if error != nil {
                completion(nil)
                return
            }
            
            //fotonun urlsını ındır
            
            imageRef.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }
}

