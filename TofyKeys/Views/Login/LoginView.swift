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
    
    @State var email: String = ""
    @State var pass: String = ""
    
    var body: some View {
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
                    TextField(LocalizedStringKey("Password"), text: $pass)
                        .textFieldStyle(LoginTextFieldStyle())
                }.padding([.top, .bottom])
                VStack {
                    Button (action: {
                        print("hola")
                    }, label: {PrincipalButtonText(LocalizedStringKey("enter"))}).buttonStyle(PrincipalButton())

                }
            }
            .padding()
            .background(.white)
            .cornerRadius(8)
            .shadow(color: .gray, radius: 8, x: 0, y: 0)
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
            Button (action: {
                print("Register")
            },label: {
                SecondaryButtonText(LocalizedStringKey("no_account"))
            })
            .buttonStyle(SecondaryButton())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
