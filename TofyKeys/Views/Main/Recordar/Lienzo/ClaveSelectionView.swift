//
//  ClaveSelectionView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 23/1/25.
//

import SwiftUI


struct ClaveSelectionView: View {
    
    @Namespace private var namespace
    @State var tipoClave: TipoClave?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(TipoClave.allCases, id: \.self) { tipoClave in
                    Button {
                        self.tipoClave = tipoClave
                    } label: {
                        VStack(spacing: 32) {
                            HStack {
                                tipoClave.icon()
                                Text(tipoClave.title())
                                    .font(Font.system(size: 22, weight: .bold))
                                Spacer()
                            }
                            Text(tipoClave.message())
                                .font(Font.system(size: 17, weight: .regular))
                                .multilineTextAlignment(.leading)
                            VStack(alignment: .leading) {
                                Text("Por ejemplo: ")
                                    .font(Font.system(size: 17, weight: .semibold))
                                Text(tipoClave.examples())
                                    .font(Font.system(size: 17, weight: .regular))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                        .matchedTransitionSource(id: tipoClave.id, in: namespace)
                    }
                }
            }
            .sheet(item: $tipoClave) { tipo in
                LienzoView(tipo: tipo)
                    .navigationTransition(.zoom(sourceID: tipo.id, in: namespace))
            }
        }
    }
}
