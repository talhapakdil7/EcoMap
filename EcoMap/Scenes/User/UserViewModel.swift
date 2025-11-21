import Foundation

final class UserViewModel {
    
    var onUserLoaded: ((String) -> Void)?
    var onLogoutSuccess: (() -> Void)?
    
    func loadUser() {
        // Kullanıcının email veya username bilgisini alıyoruz
        if let email = FirebaseAuthService.shared.currentUserEmail() {
            onUserLoaded?(email)
        } else {
            onUserLoaded?("Bilinmeyen kullanıcı")
        }
    }
    
    func logout() {
        do {
            try FirebaseAuthService.shared.signOut()
            onLogoutSuccess?()
        } catch {
            print("Çıkış yapılamadı: \(error.localizedDescription)")
        }
    }
}

