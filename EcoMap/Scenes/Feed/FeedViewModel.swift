//
//  FeedViewModel.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//

import Foundation

final class FeedViewModel {
    
    // Ekranda gösterilecek raporlar
    private(set) var reports: [Report] = []
    
    // ViewController'ın tabloyu yenilemesi için callback
    var onReportsChanged: (() -> Void)?
    
    func startListeningReports() {
        FirestoreService.shared.listenReports { [weak self] reports in
            self?.reports = reports
            self?.onReportsChanged?()
        }
    }
    
    // TableView için yardımcı fonksiyonlar:
    func numberOfItems() -> Int {
        return reports.count
    }
    
    func report(at index: Int) -> Report {
        return reports[index]
    }
}
