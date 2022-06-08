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
    
    // ADD CLAVE VARS
    @State var claveType: ClaveType = .value
    
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
            if showCreateKey {
                DismissView()
                    .onTapGesture {
                        showCreateKey = false
                    }
            }
            BottomSheetView(isOpen: $showCreateKey, maxHeight: 500) {
                AddClaveView(claveType: $claveType)
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
