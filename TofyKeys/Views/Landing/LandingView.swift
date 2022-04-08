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
    
    var body: some View {
        VStack{
            LandingTopView(showUserSettings: $showUserSettings)
                .environmentObject(userViewModel)
                .frame(height: 60)
            Spacer()
        }
        .fullScreenCover(isPresented: $showUserSettings, content: UserSettingsView.init)
    }
    
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
