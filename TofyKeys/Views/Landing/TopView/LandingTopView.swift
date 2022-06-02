//
//  LandingTopView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI
import Combine

struct LandingTopView: View {
    
    @Binding var showUserSettings: Bool
    @Binding var user: User?
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("Tofy")
                    .appTitle()
            }
            HStack {
                Spacer()
                .padding(.trailing, 16)
                Image(user?.getUserImage() ?? "user")
                    .resizable()
                    .background(Color.gray)
                    .foregroundColor(user?.character != nil ? .clear : .green)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        self.showUserSettings = true
                    }
            }
        }
        .onAppear {
            print("Landing Top View appeared")
        }
    }
}

//struct LandingTopView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingTopView(showUserSettings: .constant(false), user: .constant)
//    }
//}
