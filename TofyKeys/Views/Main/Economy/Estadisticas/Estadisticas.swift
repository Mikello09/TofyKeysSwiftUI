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
    // TRANSACTIONS
    @State var monthTransactions: [UUID: [Transaccion]] = [:]
    @State var monthCategorySelected: UUID = UUID()
    @State var selectedMonth: String = ""
    @State var timeToPlot: TimeToPlot = .last6Months
    @State var chartType: ChartType = .bar
    
    
    init(producto: Producto, categoryViewModel: TransactionCategoryViewModel) {
        self.producto = producto
        self.categoryViewModel = categoryViewModel
        estadisticaViewModel = EstadisticaViewModel(producto: producto, categoryViewModel: categoryViewModel)
        estadisticaViewModel.getCategoriesToPlot()
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
                                    monthCategorySelected = category.id
                                    emptyChartTransactions()
                                } label: {
                                    Image(systemName: categoryToSelect.image)
                                    Spacer()
                                    Text(categoryToSelect.title)
                                }
                            }
                            Section {
                                Button {
                                    estadisticaViewModel.deleteSelectedCategory(categoryToDelete: category)
                                    emptyChartTransactions()
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
                                monthCategorySelected = category.id
                                emptyChartTransactions()
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
                .padding([.top])
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
                    HStack {
                        Menu {
                            ForEach(ChartType.allCases, id: \.self) { chart in
                                Button {
                                    chartType = chart
                                    emptyChartTransactions()
                                } label: {
                                    chart.image()
                                    Spacer()
                                    Text(chart.title())
                                }
                            }
                        } label: {
                            HStack {
                                chartType.image()
                                    .foregroundStyle(Color.white)
                                Text(chartType.title())
                                    .foregroundStyle(Color.white)
                            }
                            .padding(8)
                            .background( RoundedRectangle(cornerRadius: 8).fill(.gray) )
                            .frame(height: 32)
                        }
                        Spacer()
                        Menu {
                            ForEach(TimeToPlot.allCases, id: \.self) { time in
                                Button {
                                    estadisticaViewModel.setTimeToPlot(time)
                                    timeToPlot = time
                                    emptyChartTransactions()
                                } label: {
                                    Text(time.title())
                                }
                            }
                        } label: {
                            Text(timeToPlot.title())
                                .foregroundStyle(Color.white)
                                .padding(8)
                                .background( RoundedRectangle(cornerRadius: 8).fill(.gray) )
                                .frame(height: 32)
                        }
                    }
                    .padding(.top, 8)
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
                                    if categoriesToPlot.filter({ $0.selected }).count == 1 {
                                        Text(valor.valor.toCurrency())
                                            .font(Font.system(size: 10, weight: .semibold))
                                            .foregroundStyle(Color.primaryText)
                                    } else {
                                        EmptyView()
                                    }
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
                                        estadisticaViewModel.getTransactionsForDate(month: month, year: 2024, categories: categoriesToPlot.filter({ $0.selected }).compactMap({$0.id}))
                                    }
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding(.top)
                    
                    if !monthTransactions.isEmpty {
                        Picker("", selection: $monthCategorySelected) {
                            ForEach(Array(monthTransactions.keys), id: \.self) { key in
                                let category = categoriesToPlot.first(where: { $0.id == key })!
                                Text(category.title)
                                    .tag(category.id)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        if let transactions = monthTransactions[monthCategorySelected] {
                            ForEach(transactions, id: \.self) { transaction in
                                TransactionCell(transaction: transaction, category: categoryViewModel.getCategory(id: monthCategorySelected))
                                    .padding()
                            }
                        }
                        
                    }
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
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
    
    func emptyChartTransactions() {
        selectedMonth = ""
        monthTransactions = [:]
    }
}
