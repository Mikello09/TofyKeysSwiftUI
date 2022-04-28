//
//  UserViewModel.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import Combine
import SwiftUI

enum UserViewModelError {
    case none
    case emptyInfo
    case invalidEmail
    case errorInLogin
}

class UserViewModel: ObservableObject {
    
    var loginCancellable: Cancellable?
    
    @Published var user: User?
    @Published var loginError: UserViewModelError = .none
    
    func doLogin(email: String, password: String) {
        if checkLoginParams(email: email, password: password) {
            loginCancellable = loginCall(email: email, password: password).sink(receiveCompletion: {
                switch $0 {
                case .failure(let err):
                    guard let error = err as? TofyError else {
                        return
                    }
                    self.loginError = .errorInLogin
                case .finished: ()
                }
            }, receiveValue: { user in
                self.user = user
            })
        }
    }
    
    func checkLoginParams(email: String, password: String) -> Bool {
        if email.isEmpty || password.isEmpty {
            loginError = .emptyInfo
            return false
        }
        if !email.isValidEmail() {
            loginError = .invalidEmail
            return false
        }
        return true
    }
    
}

// MARK: Login Call
extension UserViewModel {
    func loginCall(email: String, password: String) -> AnyPublisher<User,Error>{
            return crearLlamada(url: loginUrl,
                         parametros: [
                            "email": email,
                            "contrasena": password
                         ]).eraseToAnyPublisher()
        }
}
