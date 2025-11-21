import Foundation
import FirebaseFirestore

final class FirestoreService {
    
    
    static let shared = FirestoreService()
    private init() {}

    private let db = Firestore.firestore()

    // Rapor ekleme
    func addReport(_ data: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("reports").addDocument(data: data) { error in
            completion(error)
        }
    }

    // Raporları canlı dinleme
    func listenReports(completion: @escaping ([Report]) -> Void) {
        db.collection("reports")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                
                let reports: [Report] = documents.compactMap { doc in
                    let data = doc.data()
                    
                    guard
                        let userId = data["userId"] as? String,
                        let username = data["username"] as? String,
                        let imageUrl = data["imageUrl"] as? String,
                        let description = data["description"] as? String,
                        let latitude = data["latitude"] as? Double,
                        let longitude = data["longitude"] as? Double,
                        let timestamp = data["createdAt"] as? Timestamp
                    else {
                        return nil
                    }
                    
                    return Report(
                        id: doc.documentID,
                        userId: userId,
                        username: username,
                        imageUrl: imageUrl,
                        description: description,
                        latitude: latitude,
                        longitude: longitude,
                        createdAt: timestamp.dateValue()
                    )
                }
                
                completion(reports)
            }
    }
}

