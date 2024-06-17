//
//  Estadisticas.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 25/3/24.
//

import SwiftUI
import Charts

struct Estadisticas: View {
    
    @ObservedObject var estadisticaViewModel: EstadisticaViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    var producto: Producto
    
    // CATEGORIES
    @State var categoriesToPlot: [CategoryToPlot] = []
    // PLOT DATA
    @State var plotData: [EstadisticaPlotData] = []
    // SELECTION
    @State var selectedMonth = ""
    @State var monthTransactions: [Transaccion] = []
    
    init(producto: Producto, categoryViewModel: TransactionCategoryViewModel) {
        self.producto = producto
        estadisticaViewModel = EstadisticaViewModel(producto: producto, categoryViewModel: categoryViewModel)
        self.categoryViewModel = categoryViewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("¿Que quieres mostrar?")
                .font(Font.system(size: 24, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(categoriesToPlot.filter({ $0.selected }), id: \.self) { category in
                        Menu {
                            ForEach(categoriesToPlot.filter({ !$0.selected }), id: \.self) { categoryToSelect in
                                Button {
                                    estadisticaViewModel.categorySelected(selectedCategory: categoryToSelect, categoryToOverride: category)
                                } label: {
                                    Image(systemName: categoryToSelect.image)
                                    Spacer()
                                    Text(categoryToSelect.title)
                                }
                            }
                            Section {
                                Button {
                                    estadisticaViewModel.deleteSelectedCategory(categoryToDelete: category)
                                } label: {
                                    Text("Eliminar")
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8).stroke(.blue, lineWidth: 2)
                                HStack {
                                    Image(systemName: category.image)
                                    Spacer()
                                    Text(category.title)
                                    RoundedRectangle(cornerRadius: 4).fill(category.color)
                                        .frame(width: 20, height: 20)
                                }
                                .padding(8)
                            }
                            .frame(height: 32)
                        }
                    }
                    Menu {
                        ForEach(categoriesToPlot.filter({ !$0.selected }), id: \.self) { category in
                            Button {
                                estadisticaViewModel.categorySelected(selectedCategory: category)
                            } label: {
                                Image(systemName: category.image)
                                Spacer()
                                Text(category.title)
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8).fill(.blue)
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(Color.white)
                                Text("Categorias")
                                    .foregroundStyle(Color.white)
                            }
                            .padding(8)
                        }
                        .frame(height: 32)
                    }
                }
                .frame(height: 96)
                .padding([.top, .bottom])
                .padding(.leading, 2)
            }
            if plotData.isEmpty {
                VStack {
                    Spacer()
                    Text("Selecciona categoría para mostrar")
                    Spacer()
                }
            } else {
                ScrollView(.vertical) {
                    Chart {
                        ForEach(plotData, id: \.self) { data in
                            ForEach(data.valores, id: \.self) { valor in
                                BarMark(
                                    x: .value("Date", data.date.getMonthTitle()),
                                    y: .value(valor.title, valor.valor)
                                          )
                                .cornerRadius(8)
                                .foregroundStyle(selectedMonth == data.date.getMonthTitle() ? valor.color.opacity(0.5) : valor.color)
                                .annotation(position: .top) {
                                    Text(valor.valor.toCurrency())
                                        .font(Font.system(size: 10, weight: .semibold))
                                        .foregroundStyle(Color.primaryText)
                                }
                                //.position(by: .value(valor.title, valor.valor)) Para compararlos uno al lado del otro
    //                            RuleMark
                            }
                        }
                    }
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            ZStack(alignment: .top) {
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .onTapGesture { location in
                                        guard let plotFrame = proxy.plotFrame else { return }
                                        let xPosition = location.x - geometry[plotFrame].origin.x
                                        guard let month: String = proxy.value(atX: xPosition) else { return }
                                        selectedMonth = month
                                        if let categoryID = categoriesToPlot.first(where: { $0.selected })?.id {
                                            estadisticaViewModel.getTransactionsForDate(month: selectedMonth, year: 2024, category: categoryID)
                                        }
                                        print(month)
                                    }
                            }
                        }
                    }
                    .frame(height: 300)
                    if let categoryID = categoriesToPlot.first(where: { $0.selected })?.id, !selectedMonth.isEmpty {
                        ForEach(monthTransactions, id: \.self) { transaction in
                            TransactionCell(transaction: transaction, category: categoryViewModel.getCategory(id: categoryID))
                                .padding()
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear {
            estadisticaViewModel.getCategoriesToPlot()
        }
        .onReceive(estadisticaViewModel.$categoriesToSelect, perform: { categories in
            categoriesToPlot = categories
        })
        .onReceive(estadisticaViewModel.$categoriesToPlot) { plotData in
            self.plotData = plotData
        }
        .onReceive(estadisticaViewModel.$monthTransactions) { monthTransactions in
            self.monthTransactions = monthTransactions
        }
    }
}
