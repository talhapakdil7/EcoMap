//
//  SignUpViewModel.swift
//  EcoMap
//
//  Created by Talha Pakdil on 21.11.2025.
//

import Foundation

final class SignUpViewModel {
    
    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: ((String) -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?
    
    func signUp(username: String,
                email: String,
                password: String) {
        
        if username.isEmpty || email.isEmpty || password.isEmpty {
            onSignUpError?("Tüm alanları doldurmalısın.")
            return
        }
        
        isLoadingChanged?(true)
        
        FirebaseAuthService.shared.createUser(email: email,
                                              password: password,
                                              username: username) { [weak self] error in
            guard let self = self else { return }
            
            self.isLoadingChanged?(false)
            
            if let error = error {
                self.onSignUpError?(error.localizedDescription)
            } else {
                self.onSignUpSuccess?()
            }
        }
    }
}
