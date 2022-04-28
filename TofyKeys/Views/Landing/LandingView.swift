//
//  LandingView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct LandingView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var showUserSettings: Bool = false
    @State var showCreateKey: Bool = false
    
    var body: some View {
        ZStack {
            VStack{
                LandingTopView(showUserSettings: $showUserSettings)
                    .environmentObject(userViewModel)
                    .frame(height: 60)
                Spacer()
                Button {
                    showCreateKey = true
                } label: {
                    Text("New Key")
                }
            }
            BottomSheetView(isOpen: $showCreateKey, maxHeight: 400) {
                Color.red
            }.edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $showUserSettings, content: UserSettingsView.init)
    }
    
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
