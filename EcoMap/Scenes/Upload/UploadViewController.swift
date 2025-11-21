//
//  UploadViewController.swift
//

import UIKit
import CoreLocation

final class UploadViewController: UIViewController {
    
    private let viewModel = UploadViewModel()
    
    private let imageView = UIImageView()
    private let selectImageButton = UIButton(type: .system)
    private let descriptionTextField = UITextField()
    private let selectLocationButton = UIButton(type: .system)
    private let locationStatusLabel = UILabel()
    private let uploadButton = UIButton(type: .system)
    
    private var selectedImage: UIImage?
    private var selectedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Upload"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupBindings()
    }
    
    // MARK: - UI Kurulumu
    private func setupUI() {
        // imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // selectImageButton
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        selectImageButton.setTitle("Fotoğraf Seç", for: .normal)
        
        // descriptionTextField
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.placeholder = "Açıklama..."
        descriptionTextField.borderStyle = .roundedRect
        
        // selectLocationButton
        selectLocationButton.translatesAutoresizingMaskIntoConstraints = false
        selectLocationButton.setTitle("Konum Seç", for: .normal)
        
        // locationStatusLabel
        locationStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        locationStatusLabel.text = "Konum seçilmedi"
        locationStatusLabel.textAlignment = .center
        locationStatusLabel.textColor = .secondaryLabel
        locationStatusLabel.font = .systemFont(ofSize: 14)
        locationStatusLabel.numberOfLines = 0
        
        // uploadButton
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.setTitle("Paylaş", for: .normal)
        uploadButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        view.addSubview(imageView)
        view.addSubview(selectImageButton)
        view.addSubview(descriptionTextField)
        view.addSubview(selectLocationButton)
        view.addSubview(locationStatusLabel)
        view.addSubview(uploadButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            selectImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionTextField.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 44),
            
            selectLocationButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 16),
            selectLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            locationStatusLabel.topAnchor.constraint(equalTo: selectLocationButton.bottomAnchor, constant: 8),
            locationStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            uploadButton.topAnchor.constraint(equalTo: locationStatusLabel.bottomAnchor, constant: 24),
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Actions
        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        selectLocationButton.addTarget(self, action: #selector(selectLocationTapped), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
    }
    
    // MARK: - ViewModel Binding
    private func setupBindings() {
        viewModel.onUploadSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(title: "Başarılı", message: "Rapor yüklendi.")
                self?.clearForm()
            }
        }
        
        viewModel.onUploadError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showAlert(title: "Hata", message: message)
            }
        }
        
        viewModel.isLoadingChanged = { isLoading in
            print("Upload loading:", isLoading)
            // istersen ileride activity indicator ekleriz
        }
    }
    
    // MARK: - Actions
    
    @objc private func selectImageTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func selectLocationTapped() {
        let locationVC = LocationPickerViewController()
        
        locationVC.onLocationSelected = { [weak self] coordinate in
            self?.selectedCoordinate = coordinate
            let lat = (coordinate.latitude * 100).rounded() / 100
            let lon = (coordinate.longitude * 100).rounded() / 100
            self?.locationStatusLabel.text = "Konum seçildi: (\(lat), \(lon))"
        }
        
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc private func uploadTapped() {
        guard let image = selectedImage else {
            showAlert(title: "Uyarı", message: "Lütfen bir fotoğraf seçin.")
            return
        }
        
        let desc = descriptionTextField.text ?? ""
        if desc.isEmpty {
            showAlert(title: "Uyarı", message: "Açıklama boş olamaz.")
            return
        }
        
        guard let coordinate = selectedCoordinate else {
            showAlert(title: "Uyarı", message: "Lütfen haritadan konum seçin.")
            return
        }
        
        viewModel.upload(image: image,
                         description: desc,
                         latitude: coordinate.latitude,
                         longitude: coordinate.longitude)
    }
    
    // MARK: - Helpers
    
    private func clearForm() {
        selectedImage = nil
        selectedCoordinate = nil
        imageView.image = nil
        descriptionTextField.text = ""
        locationStatusLabel.text = "Konum seçilmedi"
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}


// MARK: - UIImagePickerControllerDelegate
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        }
    }
}

