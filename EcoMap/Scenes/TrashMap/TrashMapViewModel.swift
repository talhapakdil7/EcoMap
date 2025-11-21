import Foundation

final class TrashMapViewModel {
    
    private(set) var reports: [Report] = []
    
    // Harita ekranına yeni raporlar geldiğinde haber vermek için
    var onReportsChanged: (([Report]) -> Void)?
    
    func startListeningReports() {
        FirestoreService.shared.listenReports { [weak self] reports in
            self?.reports = reports
            self?.onReportsChanged?(reports)
        }
    }
}

