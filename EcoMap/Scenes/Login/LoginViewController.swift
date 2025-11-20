//
//  ViewController.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//
import UIKit

final class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
   
    @IBOutlet weak var emailTextField: UITextField!
    
  
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        // Başarılı giriş
        viewModel.onLoginSuccess = { [weak self] in
            // TabBar'a geçiş burada olacak (şimdilik sadece print)
            print("Login başarılı, tab bar'a geçilecek")
            // Bunu sonraki adımda MainTabBarController ile dolduracağız
        }
        
        // Hata durumu
        viewModel.onLoginError = { [weak self] message in
            self?.showAlert(title: "Hata", message: message)
        }
        
        // Loading durumu (ileride activity indicator ekleyebiliriz)
        viewModel.isLoadingChanged = { isLoading in
            print("Loading:", isLoading)
        }
    }
    
    
    
    
    // Login butonuna basıldığında çağrılacak (Storyboard'da IBAction bağlayacağız)
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // basit validation
        if email.isEmpty || password.isEmpty {
            showAlert(title: "Uyarı", message: "Email ve şifre boş olamaz.")
            return
        }
        
        viewModel.signIn(email: email, password: password)
    }
    
    
    
    
    // Basit alert fonksiyonu
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}


