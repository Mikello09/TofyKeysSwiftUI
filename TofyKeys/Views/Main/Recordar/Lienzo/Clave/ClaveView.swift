//
//  ClaveView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 23/1/25.
//
import SwiftUI

struct ClaveView: View {
    
    @Binding var values: [ClaveItem]
    
    var body: some View {
        VStack {
            List {
                ForEach(values, id: \.id) { value in
                    switch value.tipo {
                    case "valor": ValorItemView() { valor in updateValues(id: value.id, newValue: valor) }
                    case "user": UserItemView() { valor in updateValues(id: value.id, newValue: valor) }
                    case "password": PasswordItemView() { valor in updateValues(id: value.id, newValue: valor) }
                    default: EmptyView()
                    }
                }
            }
            Spacer()
            ClaveOptionsToolbar() { optionToAdd in
                switch optionToAdd {
                case .valor: values.append(ClaveItem(id: UUID(), idClave: UUID(), tipo: "valor", valor: "", orderNumber: values.count))
                case .user: values.append(ClaveItem(id: UUID(), idClave: UUID(), tipo: "user", valor: "", orderNumber: values.count))
                case .password: values.append(ClaveItem(id: UUID(), idClave: UUID(), tipo: "password", valor: "", orderNumber: values.count))
                }
            }
        }
    }
    
    func updateValues(id: UUID, newValue: String) {
        values = values.map({ v in
            let valueToChange = v
            if valueToChange.id == id {
                valueToChange.valor = newValue
            }
            return valueToChange
        })
    }
}

// MARK: VALOR
struct ValorItemView: View {
    @State var text: String = ""
    var onChange: ((String) -> Void)
    
    var body: some View {
        HStack {
            TextField("Valor", text: $text, axis: .vertical)
                .font(.title)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
            Spacer()
            ClaveOptions.valor.icon()
                .padding()
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: text) { oldValue, newValue in
            onChange(text)
        }
    }
}

// MARK: USER
struct UserItemView: View {
    @State var text: String = ""
    var onChange: ((String) -> Void)
    
    var body: some View {
        HStack {
            TextField("User", text: $text, axis: .vertical)
                .font(.title)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
            Spacer()
            ClaveOptions.user.icon()
                .padding()
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: text) { oldValue, newValue in
            onChange(text)
        }
    }
}
// MARK: PASSWORD
struct PasswordItemView: View {
    @State var text: String = ""
    var onChange: ((String) -> Void)
    
    @FocusState var focusShow: Bool
    @FocusState var focusHide: Bool
    
    @State var showPassword: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                SecureField("Password", text: $text)
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .focused($focusHide)
                    .opacity(showPassword ? 0 : 1)
                TextField("Password", text: $text)
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .focused($focusShow)
                    .opacity(showPassword ? 1 : 0)
            }
            Spacer()
            Button(action: {
                showPassword.toggle()
                if showPassword { focusShow = true } else { focusHide = true }
            }, label: {
                Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular))
                    .padding()
            })
            ClaveOptions.password.icon()
                .padding()
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: text) { oldValue, newValue in
            onChange(text)
        }
    }
}
