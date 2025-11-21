//
//  TrashMapViewController.swift
//  EcoMap
//

import UIKit
import MapKit

final class TrashMapViewController: UIViewController {
    
    private let viewModel = TrashMapViewModel()
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Harita"
        view.backgroundColor = .systemBackground
        
        setupMapView()
        setupBindings()
        
        viewModel.startListeningReports()
    }
    
    // MARK: - MapView Kurulumu
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    // MARK: - ViewModel Binding
    private func setupBindings() {
        viewModel.onReportsChanged = { [weak self] reports in
            DispatchQueue.main.async {
                self?.updateAnnotations(with: reports)
            }
        }
    }
    
    // MARK: - Annotation Güncelleme
    private func updateAnnotations(with reports: [Report]) {
        // Eski pinleri temizle
        mapView.removeAnnotations(mapView.annotations)
        
        // Yeni pinler
        let annotations: [MKPointAnnotation] = reports.map { report in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: report.latitude,
                                                           longitude: report.longitude)
            annotation.title = report.username
            annotation.subtitle = report.description
            return annotation
        }
        
        mapView.addAnnotations(annotations)
        
        // En az bir rapor varsa, haritayı ilk rapora göre ortala
        if let first = annotations.first {
            let region = MKCoordinateRegion(center: first.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                   longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate
extension TrashMapViewController: MKMapViewDelegate {
    
    // İstersen pin görünümünü özelleştirebilirsin
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Kullanıcı konumu pinini özelleştirmiyoruz
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "ReportPin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }
        
        view?.markerTintColor = .systemGreen
        return view
    }
}

