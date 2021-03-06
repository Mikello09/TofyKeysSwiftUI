//
//  LoginView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 18/4/22.
//

import SwiftUI
import AuthenticationServices


struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // Loading
    @State var showLoading: Bool = false
    
    // Tofy Login
    @EnvironmentObject var userViewModel: UserViewModel
    @State var email: String = ""
    @State var pass: String = ""
    @State var loginErrorDescription: LocalizedStringKey = ""
    
    // Register
    @State var goToRegister: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // MARK: NAVIGATION
                    VStack {
                        HStack {
                            Spacer()
                            Button (action: {
                                dismiss()
                            }, label: {
                                imageButton(systemName: "xmark", color: .primaryColor)
                            })
                        }
                    }.frame(height: 50)
                    
                    // MARK: LOG IN WITH TOFY
                    VStack(spacing: 0) {
                        HStack{
                            Text(LocalizedStringKey("tofy_login"))
                                .title()
                            Spacer()
                        }
                        VStack(spacing: 0) {
                            TextField(LocalizedStringKey("Email"), text: $email)
                                .textFieldStyle(LoginTextFieldStyle())
                            SecureField(LocalizedStringKey("Password"), text: $pass)
                                .textFieldStyle(LoginTextFieldStyle())
                            HStack {
                                Text(loginErrorDescription)
                                    .errorMessage()
                                    .padding(.leading)
                                Spacer()
                            }
                        }.padding([.top, .bottom])
                        VStack {
                            Button (action: {
                                showLoading = true
                                userViewModel.doLogin(email: email, password: pass)
                            }, label: {PrincipalButtonText(LocalizedStringKey("enter"))}).buttonStyle(PrincipalButton())
                        }
                    }
                    .padding()
                    .background(Color.screenBackgroundDark)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 4, x: 0, y: 0)
                    .padding()
                    
                    // MARK: CONTINUE WITH APPLE
                    SignInWithAppleButton(.continue) { request in
                        print("")
                    } onCompletion: { result in
                        print("")
                    }
                    .padding()
                    .frame(height: 92)

                    Spacer()
                    
                    // MARK: REGISTER
//                    NavigationLink(destination: RegisterView(), isActive: $goToRegister) {
//                        Button (action: {
//                            self.goToRegister = true
//                        },label: {
//                            SecondaryButtonText(LocalizedStringKey("no_account"))
//                        })
//                        .buttonStyle(SecondaryButton())
//                    }
                }
                
                // MARK: LOADING
                if showLoading {
                    VStack {
                        LottieView(name: "loading", loopMode: .loop)
                            .frame(width: 64, height: 64)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.whiteHighlighted)
                }
                
            }
            .background(Color.screenBackground)
            .navigationBarTitle("",displayMode: .inline)
            .navigationBarHidden(true)
        }.accentColor(.primaryColor)
        .onReceive(userViewModel.$loginError) { error in
            self.showLoading = false
            switch error {
            case .none:
                self.loginErrorDescription = ""
            case .emptyInfo:
                self.loginErrorDescription = LocalizedStringKey("emptyFieldError")
            case.invalidEmail:
                self.loginErrorDescription = LocalizedStringKey("invalidEmail")
            case .errorInLogin:
                self.loginErrorDescription = LocalizedStringKey("loginError")
            }
        }
        .onReceive(userViewModel.$user) { user in
            self.showLoading = false
            if let user = user, user.token != "" {
                dismiss()
            }
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
