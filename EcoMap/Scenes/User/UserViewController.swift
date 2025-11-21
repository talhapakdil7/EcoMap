//
//  UserViewController.swift
//  EcoMap
//

import UIKit

final class UserViewController: UIViewController {
    
    private let viewModel = UserViewModel()
    
    private let profileImageView = UIImageView()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupBindings()
        
        viewModel.loadUser()
    }
    
    // MARK: - UI
    private func setupUI() {
        
        // Profil Icon
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        profileImageView.tintColor = .systemGreen
        profileImageView.contentMode = .scaleAspectFit
        
        // Email
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textAlignment = .center
        emailLabel.font = .boldSystemFont(ofSize: 18)
        
        // Logout button
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Çıkış Yap", for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 10
        
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        // Add to view
        view.addSubview(profileImageView)
        view.addSubview(emailLabel)
        view.addSubview(logoutButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            emailLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onUserLoaded = { [weak self] email in
            self?.emailLabel.text = email
        }
        
        viewModel.onLogoutSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.returnToLogin()
            }
        }
    }
    
    
    // MARK: - Logout
    @objc private func logoutTapped() {
        viewModel.logout()
    }
    
    private func returnToLogin() {
        // Login ekranına dön
        self.dismiss(animated: true)
    }
}

