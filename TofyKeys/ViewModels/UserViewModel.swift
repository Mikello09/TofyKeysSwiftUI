//
//  UserViewModel.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import Combine
import SwiftUI
import CoreData

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

class UserViewModel: NSObject, ObservableObject {
    
    var getUserCancellable: Cancellable?
    var loginCancellable: Cancellable?
    var registerCancellable: Cancellable?
    
    @Published var user: User?
    @Published var loginError: LoginError = .none
    @Published var registerError: RegisterError = .none
    
    private let userController: NSFetchedResultsController<UserDB>
    
    
    // Init with local objects and then try to update data with server
    init(managedObjectContext: NSManagedObjectContext) {
        userController = NSFetchedResultsController(fetchRequest: UserDB.userDBFetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        super.init()
        userController.delegate = self
        do {
          try userController.performFetch()
            user = User.parseUserDB(userController.fetchedObjects?.first)
            print("Logged user: \(user)")
            USER_TOKEN = user?.token ?? ""
            getUser()
        } catch {
          print("failed to fetch items!")
        }
    }
}

// MARK: LOCALLY
extension UserViewModel: NSFetchedResultsControllerDelegate {
    func saveUserLocally(userToSave: User) {
        PersistenceController.shared.saveUser(user: userToSave)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let userItems = controller.fetchedObjects as? [UserDB] else { return }
        print("User DB Changed", controller.fetchedObjects?.first)
        self.user = User.parseUserDB(userItems.first)
    }
}

// MARK: GET USER
extension UserViewModel {
    func getUser() {
        if let userToken = user?.token {
            getUserCancellable = getUserCall(userToken: userToken).sink(receiveCompletion: {
                switch $0 {
                case .failure(_): ()
                case .finished: ()
                }
            }, receiveValue: { updatedUser in
                print("Updated user: \(updatedUser)")
                self.saveUserLocally(userToSave: updatedUser.usuario)
            })
        }
    }
    
    func getUserCall(userToken: String) -> AnyPublisher<UserResponse, Error> {
        return crearLlamada(url: getUserUrl,
                     parametros: [
                        "userToken": userToken
                     ]).eraseToAnyPublisher()
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
                self.saveUserLocally(userToSave: user.usuario)
                USER_TOKEN = user.usuario.token
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
    
    func loginCall(email: String, password: String) -> AnyPublisher<UserResponse, Error>{
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
            registerCancellable = registerCall(name: name, email: email, pass: pass1, character: character).sink(receiveCompletion: {
                switch $0 {
                case .finished: ()
                case .failure(let err):
                    guard let _ = err as? TofyError else {
                        return
                    }
                    self.loginError = .errorInLogin
                }
            }, receiveValue: { user in
                self.saveUserLocally(userToSave: user.usuario)
                USER_TOKEN = user.usuario.token
            })
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
    
    func registerCall(name: String, email: String, pass: String, character: String) -> AnyPublisher<UserResponse, Error> {
        return crearLlamada(url: registerUrl,
                            parametros: [
                                "email": email,
                                "pass": pass,
                                "name": name,
                                "character": character]).eraseToAnyPublisher()
    }
}

// MARK: LOGOUT
extension UserViewModel {
    func logout() {
        user = User(token: "", nombre: nil, email: "", pass: "", grupo: nil, character: nil)
    }
}
