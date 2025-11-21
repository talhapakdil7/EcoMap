//
//  TrashMapViewController.swift
//  EcoMap
//

import UIKit
import MapKit
import SDWebImage
import CoreLocation

final class TrashMapViewController: UIViewController {
    
    private let viewModel = TrashMapViewModel()
    private let mapView = MKMapView()
    
    private let locationManager = CLLocationManager()
    private var didCenterOnUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Harita"
        view.backgroundColor = .systemBackground
        
        setupMapView()
        setupLocation()
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
    
    // MARK: - Location Setup
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Kullanıcıdan izin iste
        locationManager.requestWhenInUseAuthorization()
        
        // Kullanıcı izni verirse locationManagerDelegate içinde yakalıyoruz
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

// MARK: - CLLocationManagerDelegate
extension TrashMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        // Sadece ilk açılışta kullanıcı konumuna git
        if !didCenterOnUser {
            didCenterOnUser = true
            
            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.04,
                                       longitudeDelta: 0.04)
            )
            
            mapView.setRegion(region, animated: true)
        }
    }
}

