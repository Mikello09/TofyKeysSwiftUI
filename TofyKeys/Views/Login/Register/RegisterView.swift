//
//  RegisterView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 29/4/22.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var userViewModel: UserViewModel
    
    // Loading
    @State var showLoading: Bool = false
    
    // Default values
    @State var name: String = ""
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    @State var character: String = "man_1"
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(LocalizedStringKey("Register_explanation"))
                        .title()
                    Spacer()
                }.padding()
                // TEXT FIELDS
                VStack(spacing: 0) {
                    TextField(LocalizedStringKey("Name"), text: $name)
                        .textFieldStyle(LoginTextFieldStyle())
                    TextField(LocalizedStringKey("Email"), text: $email)
                        .textFieldStyle(LoginTextFieldStyle())
                    SecureField(LocalizedStringKey("Password"), text: $password1)
                        .textFieldStyle(LoginTextFieldStyle())
                    SecureField(LocalizedStringKey("Repeat_password"), text: $password2)
                        .textFieldStyle(LoginTextFieldStyle())
                }
                // CHARACTER
                VStack(alignment: .leading) {
                    HStack {
                        Text(LocalizedStringKey("Character_election"))
                            .subtitle()
                        Spacer()
                    }
                    ChooseCharacter(choosenCharacter: $character)
                        .padding(.top, 8)
                }
                .padding([.leading, .trailing])
                .frame(height: 132)
                
                // REGISTER BUTTON
                VStack {
                    Button (action: {
                        showLoading = true
                        userViewModel.doRegister(name: name, email: email, pass1: password1, pass2: password2, character: character)
                    }, label: {PrincipalButtonText(LocalizedStringKey("Do_Register"))}).buttonStyle(PrincipalButton())
                }.padding()
                Spacer()
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
        .navigationTitle(LocalizedStringKey("register"))
        .onReceive(userViewModel.$user) { user in
            self.showLoading = false
            if let _ = user {
                dismiss()
            }
        }
    }
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
