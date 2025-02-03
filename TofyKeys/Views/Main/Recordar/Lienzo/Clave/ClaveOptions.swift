//
//  ClaveOptions.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/2/25.
//
import SwiftUI

enum ClaveOptions: String, CaseIterable {
    case valor
    case user
    case password
    
    func icon() -> Image {
        switch self {
        case .valor: Image(systemName: "character.cursor.ibeam")
        case .user: Image(systemName: "person.fill")
        case .password: Image(systemName: "key.fill")
        }
    }
    
    func title() -> String {
        switch self {
        case .valor: return "Valor"
        case .user: return "User"
        case .password: return "Password"
        }
    }
}

struct ClaveOptionsToolbar: View {
    
    var onSelect: (ClaveOptions) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(ClaveOptions.allCases, id: \.self) { tipo in
                Button {
                    onSelect(tipo)
                } label: {
                    VStack {
                        tipo.icon()
                            .frame(width: 32, height: 32)
                            .background(RoundedRectangle(cornerRadius: 4).fill(.gray).shadow(radius: 1))
                        Text(tipo.title())
                            .font(Font.system(size: 17, weight: .semibold))
                    }
                    
                }
            }
        }
        .padding()
        .border(.black)
    }
}
