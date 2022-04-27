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
    
    // CoreData
    @FetchRequest(
        entity: UserDB.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \UserDB.name, ascending: true),
        ]
    )var user: FetchedResults<UserDB>
    
    // View vars
    @Environment(\.dismiss) var dismiss
    @State var goToLogin: Bool = false
    @State var goToRegister: Bool = false
    
    
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
                if user.count != 0 {
                    LoggedUser(user: User.parseUserDB(user.first))
                } else {
                    NoLoggedUser(goToLogin: self.$goToLogin,
                                 goToRegister: self.$goToRegister)
                        .frame(height: 150)
                }
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $goToLogin, content: LoginView.init)
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
