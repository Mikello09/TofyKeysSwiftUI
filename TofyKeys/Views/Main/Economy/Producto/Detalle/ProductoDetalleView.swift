//
//  PeriodoDetalleView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 7/8/23.
//

import SwiftUI
import CoreData

enum PeriodoDetalleMenuOption: String, CaseIterable, Identifiable {
    
    var id: String { self.rawValue }
    
    case estadistica
    case categorias
    case ingreso
    case gasto
    
    func getTitle(showCategoria: Bool = false) -> String {
        switch self {
        case .estadistica: return "Estadistica"
        case .categorias: return showCategoria ? "Transacciones" : "Categorias"
        case .ingreso: return "Ingreso"
        case .gasto: return "Gasto"
        }
    }
    
    func getImage(showCategoria: Bool = false) -> Image {
        switch self {
        case .estadistica: return Image(systemName: "chart.bar.xaxis")
        case .categorias: return showCategoria ? Image(systemName: "list.bullet") : Image(systemName: "square.3.layers.3d.down.right")
        case .ingreso: return Image(systemName: "plus")
        case .gasto: return Image(systemName: "minus")
        }
    }
}

struct ProductoDetalleView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var producto: Producto
    @State var transacciones: [Transaccion] = []
    @State var actualMonth: Date = Date()
    
    @State var showCategories: Bool = false
    @State var addGasto: Bool = false
    @State var addIngreso: Bool = false
    
    @State var optionsHeight: CGFloat = 84
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                
                switch producto.tipo {
                case TipoProducto.contabilidad.rawValue:
                    HStack {
                        VStack(alignment: .leading) {
                            let difference = producto.getIngresosGastosDifference(forDate: actualMonth)
                            Text("Disponible")
                                .font(Font.system(size: 10, weight: .semibold))
                            Text(difference.toCurrency())
                                .font(Font.system(size: 32, weight: .bold))
                                .foregroundStyle(difference.resultColor())
                        }
                        Spacer()
                        VStack {
                            HStack {
                                Button(action: {
                                    actualMonth = Calendar.current.date(byAdding: .month, value: -1, to: actualMonth) ?? Date()
                                    economyViewModel.getTransacciones(producto: producto, forDate: actualMonth)
                                }, label: {
                                    Image(systemName: "chevron.left")
                                })
                                VStack {
                                    Text(actualMonth.getMonthTitle())
                                        .font(Font.system(size: 16, weight: .semibold))
                                }
                                Button(action: {
                                    actualMonth = Calendar.current.date(byAdding: .month, value: 1, to: actualMonth) ?? Date()
                                    economyViewModel.getTransacciones(producto: producto, forDate: actualMonth)
                                }, label: {
                                    Image(systemName: "chevron.right")
                                })
                            }
                            Text(actualMonth.getYear())
                                .font(Font.system(size: 10, weight: .semibold))
                        }
                    }
                    .padding()
                default: EmptyView()
                }
                
                HStack(spacing: 0) {
                    ForEach(PeriodoDetalleMenuOption.allCases) { option in
                    
                        PeriodoDetalleMenuOptionView(option: option, showCategories: $showCategories) {
                            switch option {
                            case .estadistica: ()
                            case .categorias: showCategories.toggle()
                            case .gasto: addGasto = true
                            case.ingreso: addIngreso = true
                            }
                        }
                        .frame(width: proxy.size.width/4)
                        
                    }
                }
                .frame(height: optionsHeight)
                .padding([.top, .bottom])
                
                if transacciones.isEmpty {
                    VStack {
                        Spacer()
                        Text("No hay movimientos")
                        Spacer()
                    }
                } else {
                    if showCategories {
                        List {
                            ForEach(producto.getCategories(forDate: actualMonth)) { categoryItem in
                                let category = categoryViewModel.getCategory(id: categoryItem.category)
                                CategoryCell(item: categoryItem, category: category)
                            }
                        }
                    } else {
                        
                            List {
                                ForEach(transacciones.sorted(by: { $0.fecha > $1.fecha })) { transaccion in
                                    TransactionCell(transaction: transaccion, category: categoryViewModel.getCategory(id: transaccion.category))
                                        .contextMenu {
                                            Button {
                                                economyViewModel.deletePeriodoTransaction(transactionID: transaccion.id, periodo: producto)
                                            } label: {
                                                HStack {
                                                    Text("Eliminar")
                                                    Spacer()
                                                    Image(systemName: "trash.fill")
                                                }
                                            }
                                        }
                                        .overlay (
                                            NavigationLink (destination: {
                                                TransferDetailView(categoryViewModel: categoryViewModel,
                                                                   transfer: transaccion,
                                                                   onEdit: onEdit,
                                                                   onDelete: onDelete) }
                                                , label: {EmptyView() } ).opacity(0)
                                        )
                                }
                            }
                    }
                }
            }
            .navigationTitle(producto.titulo)
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $addGasto, content: {
                AddTransferenciaView(categoryViewModel: categoryViewModel, tipo: "gasto", onAdd: onAdd)
            })
            .sheet(isPresented: $addIngreso) {
                AddTransferenciaView(categoryViewModel: categoryViewModel, tipo: "ingreso", onAdd: onAdd)
            }
            .onAppear {
                economyViewModel.getTransacciones(producto: producto, forDate: Date())
            }
            .onReceive(economyViewModel.$dbProductos, perform: { periodos in
                if let detalle = periodos.filter({ $0.id == producto.id }).first {
                    producto = Producto.parseProductoDB(detalle)
                    economyViewModel.getTransacciones(producto: producto, forDate: actualMonth)
                }
            })
            .onReceive(economyViewModel.$transaciones, perform: { transacciones in
                self.transacciones = transacciones
            })
        }
    }
    
    func onAdd(titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        economyViewModel.addTransaction(periodo: producto,
                                        titulo: titulo,
                                        tipo: tipo,
                                        valor: valor,
                                        category: category,
                                        observacion: observacion,
                                        fecha: fecha)
        addGasto = false
        addIngreso = false
    }
    
    func onEdit(id: UUID, titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        economyViewModel.editTransaction(periodo: producto, id: id, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion, fecha: fecha)
    }
    
    func onDelete(transaccion: Transaccion) {
        economyViewModel.deletePeriodoTransaction(transactionID: transaccion.id, periodo: producto)
    }
}

struct ToffyPreferencKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        print("REDUCE: \(nextValue())")
        value += nextValue()
    }
}

// MARK: TRANSACTION CELL
struct TransactionCell: View {
    
    var transaction: Transaccion
    var category: Category
    
    var body: some View {
        
            HStack {
                Image(systemName: category.image)
                    .frame(width: 32, height: 32)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing, 8)
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(transaction.titulo)
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.primaryColor)
                        Text(transaction.fecha.toDayString())
                            .font(Font.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.secondaryColor)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(transaction.valor.toCurrency())
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundStyle(transaction.tipo == "ingreso" ? .green : .red)
                        Text(category.title)
                            .font(Font.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.secondaryColor)
                    }
                }
                Spacer()
            }
        
    }
}
// MARK: CATEGORY CELL
struct CategoryCell: View {
    
    var item: CategoriaItem
    var category: Category
    
    @State var showDetails: Bool = false
    
    var body: some View {
        VStack {
            Button {
                showDetails.toggle()
            } label: {
                HStack {
                    Image(systemName: category.image)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.blackTofy)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 8)
                    Text(category.title)
                        .font(Font.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.primaryColor)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(item.value.toCurrency())
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundStyle(item.value >= 0 ? .green : .red)
                        HStack {
                            if item.numericalComparison > 0 {
                                Image(systemName: "arrowtriangle.up.fill")
                                    .foregroundStyle(.green)
                            } else if item.numericalComparison == 0 {
                                Image(systemName: "equal")
                                    .foregroundStyle(.gray)
                            } else {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundStyle(.red)
                            }
                            Text("\(item.numericalComparison.roundedTo2Decimals())")
                                .font(Font.system(size: 14, weight: .semibold))
                                .foregroundStyle(item.numericalComparison >= 0 ? .green : .red)
                        }
                    }
                }
                if showDetails {
                    VStack(spacing: 16) {
                        ForEach(item.transactions) { transaction in
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(transaction.titulo)
                                        .font(Font.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Color.primaryColor)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text(transaction.valor.toCurrency())
                                        .font(Font.system(size: 14, weight: .semibold))
                                        .foregroundStyle(transaction.tipo == "ingreso" ? .green : .red)
                                    Text(transaction.fecha.toDayString())
                                        .font(Font.system(size: 12, weight: .regular))
                                        .foregroundStyle(Color.secondaryColor)
                                }
                            }
                            if transaction != item.transactions.last {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.categoryDetailBackground)
                    }
                }
            }
        }
    }
}

// MARK: MENU OPTION
struct PeriodoDetalleMenuOptionView: View {
    
    var option: PeriodoDetalleMenuOption
    @Binding var showCategories: Bool
    var completion: (() -> Void)
    
    var body: some View {
        VStack {
            Button {
                completion()
            } label: {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 24, height: 24))
                        .fill(.cyan)
                    option.getImage(showCategoria: showCategories)
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 48, height: 48)
            Text(option.getTitle(showCategoria: showCategories))
                .font(Font.system(size: 14))
        }
        
    }
}
