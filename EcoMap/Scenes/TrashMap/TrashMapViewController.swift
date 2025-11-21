//
//  TrashMapViewController.swift
//  EcoMap
//

import UIKit
import MapKit
import SDWebImage

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
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations: [ReportAnnotation] = reports.map { report in
            return ReportAnnotation(report: report)
        }
        
        mapView.addAnnotations(annotations)
        
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
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
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
        
        // Callout'ta fotoğraf göstermek
        if let reportAnnotation = annotation as? ReportAnnotation {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 6
            if let url = URL(string: reportAnnotation.imageUrl) {
                imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            } else {
                imageView.image = UIImage(systemName: "photo")
            }
            view?.leftCalloutAccessoryView = imageView
        }
        
        return view
    }
}

