//
//  ParkingView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 14/5/23.
//

import SwiftUI

struct ParkingView: View {
    
    @State var parkings: [Parking] = []
    @State var showAddParking: Bool = false
    
    var body: some View {
        TofyNavigation {
            ZStack {
                if parkings.isEmpty {
                    VStack {
                        Spacer()
                        LottieView(name: "add", loopMode: .loop)
                            .frame(width: 64, height: 64)
                            .onTapGesture {
                                self.showAddParking = true
                            }
                        Text(LocalizedStringKey("EmptyParking"))
                            .title()
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 64)
                        Spacer()
                    }
                } else {
                    Text("Parkings")
                }
            }
            .navigationTitle(LocalizedStringKey("Parking"))
            .toolbar(content: {
                Button (action: {
                    self.showAddParking = true
                }, label: {
                    imageButton(systemName: "plus.circle", color: .primaryColor, size: 24)
                })
            })
            .background(Image("tofy_background"))
        }
        .sheet(isPresented: $showAddParking) {
            AddParkingView()
        }
    }
}
