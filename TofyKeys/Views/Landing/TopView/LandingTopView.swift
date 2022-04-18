//
//  LandingTopView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct LandingTopView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @Binding var showUserSettings: Bool
    
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("Tofy")
                    .appTitle()
            }
            HStack {
                Spacer()
                .padding(.trailing, 16)
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        self.showUserSettings = true
                    }
            }
        }
    }
}

struct LandingTopView_Previews: PreviewProvider {
    static var previews: some View {
        LandingTopView(showUserSettings: .constant(false))
    }
}
