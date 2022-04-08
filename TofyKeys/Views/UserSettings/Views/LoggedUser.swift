//
//  LoggedUser.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct LoggedUser: View {
    
    @State var user: User
    
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .resizable()
                .foregroundColor(.green)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .frame(width: 96, height: 96)
                .padding(.trailing, 16)
            Spacer()
            Text(user.name)

        }
    }
}

struct LoggedUser_Previews: PreviewProvider {
    static var previews: some View {
        LoggedUser(user: User(token: "", name: "", email: "", pass: ""))
    }
}
