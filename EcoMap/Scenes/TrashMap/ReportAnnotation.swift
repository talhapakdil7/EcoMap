//
//  ReportAnnotation.swift
//  EcoMap
//
//  Created by Talha Pakdil on 21.11.2025.
//

//
//  ReportAnnotation.swift
//  EcoMap
//

import Foundation
import MapKit

final class ReportAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let imageUrl: String
    
    init(report: Report) {
        self.coordinate = CLLocationCoordinate2D(latitude: report.latitude,
                                                 longitude: report.longitude)
        self.title = report.username
        self.subtitle = report.description
        self.imageUrl = report.imageUrl
    }
}
