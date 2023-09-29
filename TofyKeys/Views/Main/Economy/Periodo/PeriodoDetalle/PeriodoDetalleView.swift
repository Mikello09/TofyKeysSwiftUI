//
//  PeriodoDetalleView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 7/8/23.
//

import SwiftUI
import CoreData

struct PeriodoDetalleView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    var periodo: Periodo
    @State var showingTipo: String = "gasto"
    
    var body: some View {
        VStack {
            Text(periodo.getIngresosGastosDifference().toCurrency())
                .font(Font.system(size: 32, weight: .bold))
            HStack {
                ForEach(PeriodoDetalleMenuOption.allCases) { option in
                
                    PeriodoDetalleMenuOptionView(option: option) {
                        switch option {
                        case .estadistica: ()
                        case .categorias: ()
                        case .gasto: ()
                        case.ingreso: ()
                        }
                    }
                    
                }
            }
            .padding()
            
            if periodo.transacciones.isEmpty {
                VStack {
                    Spacer()
                    Text("No hay movimientos")
                    Spacer()
                }
            } else {
                List(periodo.transacciones, id: \.self) { gasto in
                    TransactionCell(transaction: gasto, category: categoryViewModel.getCategory(id: gasto.category))
                        .contextMenu {
                            Button {
                                economyViewModel.deletePeriodoTransaction(transactionID: gasto.id, periodo: periodo)
                            } label: {
                                HStack {
                                    Text("Eliminar")
                                    Spacer()
                                    Image(systemName: "trash.fill")
                                }
                            }
                        }
                }
            }
        }
        .navigationTitle(periodo.titulo)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct TransactionCell: View {
    
    var transaction: Transaccion
    var category: Category
    
    var body: some View {
        HStack {
            category.image
            VStack(alignment: .leading) {
                Text(transaction.titulo)
                Text(transaction.valor.toCurrency())
            }
            Spacer()
        }
    }
}

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
        case .categorias: return Image(systemName: "")
        case .ingreso: return Image(systemName: "")
        case .gasto: return Image(systemName: "")
        }
    }
}

struct PeriodoDetalleMenuOptionView: View {
    
    var option: PeriodoDetalleMenuOption
    var completion: (() -> Void)
    
    var body: some View {
        VStack {
            Button {
                completion()
            } label: {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                        .fill(.gray)
                    option.getImage()
                }
            }
            .frame(width: 32, height: 32)
            Text(option.getTitle())
                .font(Font.system(size: 14))
        }
    }
}
