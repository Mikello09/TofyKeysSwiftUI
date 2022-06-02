//
//  NoLoggedUser.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct NoLoggedUser: View {
    
    @Binding var goToLogin: Bool
    @Binding var goToRegister: Bool
    
    var body: some View {
        VStack {
            Image("user")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .tint(.red)
                .background(Color.gray)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .frame(width: 96, height: 96)
            Spacer()
            Button (action: {
                self.goToLogin = true
            }, label: {
                textButton(text: LocalizedStringKey("loginOrRegister"))
            })


        }
    }
}

struct NoLoggedUser_Previews: PreviewProvider {
    static var previews: some View {
        NoLoggedUser(goToLogin: .constant(false), goToRegister: .constant(false))
    }
}
