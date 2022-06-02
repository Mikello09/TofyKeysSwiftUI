//
//  LoggedUser.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct LoggedUser: View {
    
    @Binding var user: User?
    
    var body: some View {
        VStack {
            Image(user?.getUserImage() ?? "user")
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .frame(width: 96, height: 96)
            Text(user?.nombre ?? "-")
            Spacer()
        }
    }
}

//struct LoggedUser_Previews: PreviewProvider {
//    static var previews: some View {
//        LoggedUser(user: User(token: "", name: "", email: "", pass: ""))
//    }
//}
