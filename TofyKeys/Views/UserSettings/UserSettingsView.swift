//
//  SettingsView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct UserSettingsView: View {
    // ViewModels
    @EnvironmentObject var userViewModel: UserViewModel
    
    // View vars
    @Environment(\.dismiss) var dismiss
    @State var goToLogin: Bool = false
    @State var goToRegister: Bool = false
    
    @State var user: User?
    
    var body: some View {
        VStack(alignment: .center) {
            // Navigation
            HStack{
                Spacer()
                Button (action: {
                    dismiss()
                }, label: {
                    imageButton(systemName: "xmark", color: .primaryColor)
                })
            }
            // User info
            VStack {
                if user?.isLogged() ?? false {
                    LoggedUser(user: $user)
                        .frame(height: 150)
                } else {
                    NoLoggedUser(goToLogin: self.$goToLogin,
                                 goToRegister: self.$goToRegister)
                        .frame(height: 150)
                }
                
            }
            Spacer()
            if user?.isLogged() ?? false {
                Button {
                    userViewModel.logout()
                } label: {
                    TextButton(text: LocalizedStringKey("Logout"), foregroundColor: .redTofy)
                }
            }
        }
        .fullScreenCover(isPresented: $goToLogin){
            LoginView().environmentObject(userViewModel)
        }
        .onReceive(userViewModel.$user) { user in
            self.user = user
        }
    }
}

//struct UserSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSettingsView()
//    }
//}
