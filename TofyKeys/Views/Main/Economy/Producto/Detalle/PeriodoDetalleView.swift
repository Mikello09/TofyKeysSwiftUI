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
    
    func getTitle() -> String {
        switch self {
        case .estadistica: return "Estadistica"
        case .categorias: return "Categorias"
        case .ingreso: return "Ingreso"
        case .gasto: return "Gasto"
        }
    }
    
    func getImage() -> Image {
        switch self {
        case .estadistica: return Image(systemName: "chart.bar.xaxis")
        case .categorias: return Image(systemName: "line.3.horizontal.decrease.circle.fill")
        case .ingreso: return Image(systemName: "plus")
        case .gasto: return Image(systemName: "minus")
        }
    }
}

struct PeriodoDetalleView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var periodo: Producto
    @State var showingTipo: String = "gasto"
    
    @State var showCategories: Bool = false
    @State var addGasto: Bool = false
    @State var addIngreso: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(periodo.getIngresosGastosDifference().toCurrency())
                    .font(Font.system(size: 32, weight: .bold))
                HStack(spacing: 0) {
                    ForEach(PeriodoDetalleMenuOption.allCases) { option in
                    
                        PeriodoDetalleMenuOptionView(option: option) {
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
                .padding([.top, .bottom])
                
                if periodo.transacciones.isEmpty {
                    VStack {
                        Spacer()
                        Text("No hay movimientos")
                        Spacer()
                    }
                } else {
                    if showCategories {
                        List {
                            ForEach(periodo.getCategories()) { categoryItem in
                                let category = categoryViewModel.getCategory(id: categoryItem.category)
                                CategoryCell(item: categoryItem, category: category)
                            }
                        }
                    } else {
                        List {
                            ForEach(periodo.transacciones.sorted(by: { $0.fecha > $1.fecha })) { transaccion in
                                TransactionCell(transaction: transaccion, category: categoryViewModel.getCategory(id: transaccion.category))
                                    .contextMenu {
                                        Button {
                                            economyViewModel.deletePeriodoTransaction(transactionID: transaccion.id, periodo: periodo)
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
            .navigationTitle(periodo.titulo)
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $addGasto, content: {
                AddTransferenciaView(categoryViewModel: categoryViewModel, tipo: "gasto", onAdd: onAdd)
            })
            .sheet(isPresented: $addIngreso) {
                AddTransferenciaView(categoryViewModel: categoryViewModel, tipo: "ingreso", onAdd: onAdd)
            }
            .onReceive(economyViewModel.$dbProductos, perform: { periodos in
                if let detalle = periodos.filter({ $0.id == periodo.id }).first {
                    periodo = Producto.parseProductoDB(detalle)
                }
            })
        }
    }
    
    func onAdd(titulo: String, tipo: String, valor: Double, category: UUID, observacion: String, fecha: Date) {
        economyViewModel.addTransaction(periodo: periodo,
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
        economyViewModel.editTransaction(periodo: periodo, id: id, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion, fecha: fecha)
    }
    
    func onDelete(transaccion: Transaccion) {
        economyViewModel.deletePeriodoTransaction(transactionID: transaccion.id, periodo: periodo)
    }
}
// MARK: TRANSACTION CELL
struct TransactionCell: View {
    
    var transaction: Transaccion
    var category: Category
    
    var body: some View {
        
            HStack {
                category.image
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
    
    var body: some View {
        HStack {
            category.image
                .frame(width: 32, height: 32)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 8)
            Text(category.title)
                .font(Font.system(size: 14, weight: .semibold))
            Spacer()
            Text(item.value.toCurrency())
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(item.value >= 0 ? .green : .red)
        }
    }
}

// MARK: MENU OPTION
struct PeriodoDetalleMenuOptionView: View {
    
    var option: PeriodoDetalleMenuOption
    var completion: (() -> Void)
    
    var body: some View {
        VStack {
            Button {
                completion()
            } label: {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 24, height: 24))
                        .fill(.cyan)
                    option.getImage()
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 48, height: 48)
            Text(option.getTitle())
                .font(Font.system(size: 14))
        }
        
    }
}
