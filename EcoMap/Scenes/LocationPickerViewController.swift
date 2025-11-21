//
//  LocationPickerViewController.swift
//  EcoMap
//
//  Created by Talha Pakdil on 21.11.2025.
//

import UIKit
import MapKit
import CoreLocation

final class LocationPickerViewController: UIViewController {
    
    // Seçilen konumu UploadViewController'a geri göndereceğimiz closure
    var onLocationSelected: ((CLLocationCoordinate2D) -> Void)?
    
    private let mapView = MKMapView()
    private var selectedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Konum Seç"
        view.backgroundColor = .systemBackground
        
        setupMapView()
        setupNavigationBar()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.showsUserLocation = true
        
        // Uzun basma gesture'ı ekle
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
    }
    
    private func setupNavigationBar() {
        // Sağ üstte "Seç" butonu
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Seç",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(selectButtonTapped))
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            // Önce eski anotasyonları temizle
            mapView.removeAnnotations(mapView.annotations)
            
            // Yeni anotasyon ekle
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Seçilen Konum"
            mapView.addAnnotation(annotation)
            
            selectedCoordinate = coordinate
        }
    }
    
    @objc private func selectButtonTapped() {
        guard let coordinate = selectedCoordinate else {
            let alert = UIAlertController(title: "Uyarı",
                                          message: "Lütfen haritada uzun basarak bir konum seçin.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Koordinatı geri gönder
        onLocationSelected?(coordinate)
        
        // Ekranı kapat (push ile açtıysak pop yeterli)
        navigationController?.popViewController(animated: true)
    }
}
