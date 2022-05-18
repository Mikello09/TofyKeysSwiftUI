//
//  UserViewModel.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import Combine
import SwiftUI

enum LoginError {
    case none
    case emptyInfo
    case invalidEmail
    case errorInLogin
}

enum RegisterError {
    case none
    case emptyInfo
    case invalidEmail
    case differentPassword
    case errorInRegister
}

class UserViewModel: ObservableObject {
    
    var loginCancellable: Cancellable?
    
    @Published var user: User?
    @Published var loginError: LoginError = .none
    @Published var registerError: RegisterError = .none
    
    func saveUser(userToSave: User) {
        
    }
    
}

// MARK: LOGIN
extension UserViewModel {
    func doLogin(email: String, password: String) {
        if checkLoginParams(email: email, password: password) {
            loginCancellable = loginCall(email: email, password: password).sink(receiveCompletion: {
                switch $0 {
                case .failure(let err):
                    guard let _ = err as? TofyError else {
                        return
                    }
                    self.loginError = .errorInLogin
                case .finished: ()
                }
            }, receiveValue: { user in
                self.user = user.usuario
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
    
    func loginCall(email: String, password: String) -> AnyPublisher<UserResponse,Error>{
        return crearLlamada(url: loginUrl,
                     parametros: [
                        "email": email,
                        "contrasena": password
                     ]).eraseToAnyPublisher()
    }
}

// MARK: REGISTER
extension UserViewModel {
    func doRegister(name: String, email: String, pass1: String, pass2: String, character: String) {
        if checkRegisterParams(name: name, email: email, pass1: pass1, pass2: pass2, character: character) {
            
        }
    }
    
    func checkRegisterParams(name: String, email: String, pass1: String, pass2: String, character: String) -> Bool {
        if name.isEmpty || email.isEmpty || pass1.isEmpty || pass2.isEmpty {
            registerError = .emptyInfo
            return false
        }
        if !email.isValidEmail() {
            registerError = .invalidEmail
            return false
        }
        if pass1 != pass2 {
            registerError = .differentPassword
            return false
        }
        return true
    }
}
