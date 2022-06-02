//
//  LandingView.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import SwiftUI

struct LandingView: View {
    
    // ViewModels
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var claveViewModel: ClaveViewModel
    
    @State var showUserSettings: Bool = false
    @State var showCreateKey: Bool = false
    
    @State var user: User?
    
    var body: some View {
        ZStack {
            VStack{
                LandingTopView(showUserSettings: $showUserSettings, user: $user)
                    .frame(height: 60)
                Spacer()
                Button (action: {
                    showCreateKey = true
                }, label: {
                    PrincipalButtonText(LocalizedStringKey("Add_new_key"))
                }).buttonStyle(PrincipalButton())
            }
            BottomSheetView(isOpen: $showCreateKey, maxHeight: 400) {
                Color.red
            }.edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $showUserSettings){
            UserSettingsView().environmentObject(userViewModel)
        }
        .onReceive(userViewModel.$user) { user in
            self.user = user
        }
    }
    
}

//struct LandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingView()
//    }
//}
