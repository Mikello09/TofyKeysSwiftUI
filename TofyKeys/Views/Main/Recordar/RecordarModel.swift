//
//  RecordarModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 22/11/24.
//
import SwiftUI

enum TipoClave: String, CaseIterable {
    case value
    case user
    case password
    case nota//enrichedtext
    case list
    
    func icon() -> Image {
        switch self {
        case .value: Image(systemName: "character.cursor.ibeam")
        case .password: Image(systemName: "key.fill")
        case .user: Image(systemName: "person.fill")
        case .nota: Image(systemName: "note.text")
        case .list: Image(systemName: "list.bullet")
        }
    }
    
    func title() -> String {
        switch self {
        case .value: return "Valor"
        case .password: return "Pass"
        case .user: return "User"
        case .nota: return "Nota"
        case .list: return "Lista"
        }
    }
}

extension String {
    func toTipoClave() -> TipoClave {
        switch self {
        case TipoClave.value.rawValue: return .value
        case TipoClave.password.rawValue: return .password
        case TipoClave.user.rawValue: return .user
        case TipoClave.nota.rawValue: return .nota
        case TipoClave.list.rawValue: return .list
        default: return .value
        }
    }
}

struct Clave: Equatable {
    
    var id: UUID
    var titulo: String
    var items: [ClaveItem]
    
    static func == (lhs: Clave, rhs: Clave) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ClaveItem: Equatable {
    var id: UUID = UUID()
    var tipo: TipoClave
    var values: [String] = []
}

struct ClaveItemView: View {
    
    @Binding var clave: ClaveItem
    var onDelete: ((ClaveItem) -> Void)?
    
    var body: some View {
        ZStack {
            switch clave.tipo {
            case .value: ValueItem(values: $clave.values)
            case .user: UserItem(values: $clave.values)
            case .password: PasswordItem(values: $clave.values)
            case .nota: NotaItem(values: $clave.values)
            case .list: ListItem(clave.values)
            }
        }
        .contextMenu {
            Button {
                onDelete?(clave)
            } label: {
                Text("Eliminar")
            }

        }
    }
}
// MARK: VALUE
struct ValueItem: View {

    @State var text: String = ""
    @Binding var values: [String]
    
    var body: some View {
        HStack {
            TextField("Value", text: $text, axis: .vertical)
                .font(.title)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
            Spacer()
            TipoClave.value.icon()
                .padding()
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: text) { oldValue, newValue in
            values = [newValue]
        }
    }
}
// MARK: USER
struct UserItem: View {
    @State var text: String = ""
    @Binding var values: [String]
    
    var body: some View {
        HStack {
            TextField("User", text: $text, axis: .vertical)
                .font(.title)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
            Spacer()
            TipoClave.user.icon()
                .padding()
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: text) { oldValue, newValue in
            values = [newValue]
        }
    }
}
// MARK: PASSWORD
struct PasswordItem: View {
    @State var text: String = ""
    @Binding var values: [String]
    
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
            TipoClave.password.icon()
                .padding()
        }
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: text) { oldValue, newValue in
            values = [newValue]
        }
    }
}
// MARK: NOTA
struct NotaItem: View {
    @State var text: String = ""
    @Binding var values: [String]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                TextField("Nota", text: $text, axis: .vertical)
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                Spacer()
                TipoClave.nota.icon()
                    .padding()
            }
            .onChange(of: text) { oldValue, newValue in
                values = [newValue]
            }
            Spacer()
        }
        .frame(minHeight: 200)
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ListItem: View {
    var values: [String]
    init(_ values: [String]) {
        self.values = values
    }
    
    var body: some View {
        Text("List")
    }
}
