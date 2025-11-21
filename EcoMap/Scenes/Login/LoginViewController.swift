import UIKit

final class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // Uygulama açıldığında, kullanıcı zaten giriş yaptıysa
    // login ekranını atlayıp direkt TabBar'a geçiyoruz
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuthService.shared.isLoggedIn() {
            navigateToMainTabBar()
        }
    }
    
    private func setupBindings() {
        
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToMainTabBar()
            }
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
    
    // Ortak: TabBar'a geç
    private func navigateToMainTabBar() {
        let tabBar = MainTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let signUpVC = SignUpViewController()
                signUpVC.modalPresentationStyle = .fullScreen
                present(signUpVC, animated: true)
    }
    
    
    // Login butonuna basılınca
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            showAlert(title: "Uyarı", message: "Email ve şifre boş olamaz.")
            return
        }
        
        viewModel.signIn(email: email, password: password)
    }
    
    // Basit alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

