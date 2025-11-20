//
//  LoginViewModel.swift
//  EcoMap
//
//  Created by Talha Pakdil on 20.11.2025.
//

import Foundation

final class LoginViewModel {
    
    // ViewController'a haber vermek için closure'lar
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?
    
    func signIn(email: String, password: String) {
        
        // Yükleniyor bilgisi (ileride spinner vs. için)
        isLoadingChanged?(true)
        
        FirebaseAuthService.shared.signIn(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            
            // işlem bitti
            self.isLoadingChanged?(false)
            
            if let error = error {
                // hata varsa ViewController'a mesaj gönder
                self.onLoginError?(error.localizedDescription)
            } else {
                // giriş başarılı
                self.onLoginSuccess?()
            }
        }
    }
}
