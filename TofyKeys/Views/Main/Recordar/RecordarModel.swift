//
//  RecordarModel.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 22/11/24.
//
import SwiftUI

enum TipoClave: String, CaseIterable, Identifiable {
    var id: Self { return self }
    
    case clave
    case nota//enrichedtext
    case list
    
    func icon() -> Image {
        switch self {
        case .clave: Image(systemName: "key.fill")
        case .nota: Image(systemName: "note.text")
        case .list: Image(systemName: "list.bullet")
        }
    }
    
    func title() -> String {
        switch self {
        case .clave: return "Clave"
        case .nota: return "Nota"
        case .list: return "Lista"
        }
    }
    
    func message() -> String {
        switch self {
        case .clave: return "Ideal para guardar algún tipo de contraseña secreta, como tu clave de Apple ID, tu contraseña de correo electrónico o tu clave de Spotify. También puedes añadir un campo de usuario si es necesario."
        case .nota: return "Crea textos largos que contengan información relevante para ti. Expon tus ideas de manera organizada y con claridad."
        case .list: return "Anota una lista de tareas o de elementos que te ayuden a organizar tu tiempo o tu vida. Puedes marcarlos como realizados una vez terminadas las tareas."
        }
    }
    
    func examples() -> String {
        switch self {
        case .clave: return "Clave del WiFi, contraseña del ordenador, usuario de Netflix..."
        case .nota: return "Borrador de una exposicion, ideas de un proyecto, plan de un viaje..."
        case .list: return "Lista de la compra, tareas del día, tareas de la semana..."
        }
    }
}

extension String {
    func toTipoClave() -> TipoClave {
        switch self {
        case TipoClave.clave.rawValue: return .clave
        case TipoClave.nota.rawValue: return .nota
        case TipoClave.list.rawValue: return .list
        default: return .clave
        }
    }
}

//struct Clave: Equatable {
//    
//    var id: UUID
//    var titulo: String
//    var items: [ClaveItem]
//    
//    static func == (lhs: Clave, rhs: Clave) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
//
//struct ClaveItem: Equatable {
//    var id: UUID = UUID()
//    var tipo: TipoClave
//    var values: [String] = []
//}
//
//struct ClaveItemView: View {
//    
//    @Binding var clave: ClaveItem
//    var onDelete: ((ClaveItem) -> Void)?
//    
//    var body: some View {
//        //VStack {
//            switch clave.tipo {
//            case .clave: UserItemView(values: $clave.values)
//            case .nota: NotaItemView(values: $clave.values)
//            case .list: ListItemView(values: $clave.values)
//            }
//        //}
////        .contextMenu {
////            Button {
////                onDelete?(clave)
////            } label: {
////                Text("Eliminar")
////            }
////
////        }
//    }
//}

// MARK: NOTA
struct NotaItemView: View {
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
// MARK: LISTA
struct ListaItem: Hashable {
    var id: UUID = UUID()
    var value: String
    var selected: Bool = false
    
    func toString() -> String {
        return value + "$$" + (selected ? "1" : "0")
    }
}

struct ListItemView: View {
    
    @Binding var values: [String]
    @State var items: [ListaItem] = [ListaItem(value: "Huevos"), ListaItem(value: "Arroz")]
    
    @State var addItem: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TipoClave.list.icon()
            }
            .padding()
            if items.isEmpty {
                Image("clipboard-list-outline-filled")
                    .padding()
            } else {
                ForEach(items, id: \.self) { item in
                    Button {
                        items = items.compactMap({ i in
                            var it = i
                            if it.id == item.id {
                                it.selected.toggle()
                            }
                            return it
                        })
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(.green, lineWidth: 2)
                                    .frame(width: 32, height: 32)
                                if item.selected {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Text(item.value)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
                .onMove(perform: moveRow)
            }
            HStack {
                Spacer()
                Button {
                    addItem = true
                } label: {
                    Text("Añadir")
                        .font(Font.system(size: 24, weight: .bold))
                        .foregroundStyle(.blue)
                }
            }
            .padding()
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $addItem, content: {
            AddListItemView() { itemAdded in
                addItem = false
                items.append(ListaItem(value: itemAdded))
            }
        })
        .background(Color.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onChange(of: items) { oldValue, newValue in
            values = newValue.compactMap({ $0.toString()})
        }
    }
    
    private func moveRow(source: IndexSet, destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}



struct AddListItemView: View {
    
    @State var items: [String] = []
    @State var searchText: String = ""
    
    var onItemAdded: ((String) -> Void)
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(items, id: \.self) { item in
                    Button {
                        onItemAdded(item)
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text(item)
                            Spacer()
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText, prompt: "Buscar")
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                items = [newValue]
            }
        }
        
    }
}
