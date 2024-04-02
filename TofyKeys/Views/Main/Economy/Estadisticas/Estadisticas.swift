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
    
    var producto: Producto
    
    // CATEGORIES
    @State var categoriesToPlot: [CategoryToPlot] = []
    // PLOT DATA
    @State var plotData: [EstadisticaPlotData] = []
    
    init(producto: Producto, categoryViewModel: TransactionCategoryViewModel) {
        self.producto = producto
        estadisticaViewModel = EstadisticaViewModel(producto: producto, categoryViewModel: categoryViewModel)
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
                            ForEach(categoriesToPlot.filter({ !$0.selected }), id: \.self) { category in
                                Button {
                                    estadisticaViewModel.categorySelected(selectedCategory: category, overriding: true)
                                } label: {
                                    Image(systemName: category.image)
                                    Spacer()
                                    Text(category.title)
                                }

                            }
                        } label: {
                            HStack {
                                Image(systemName: category.image)
                                Spacer()
                                Text(category.title)
                            }
                            
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
                        Text("Categorias")
                        
                    }
                }
                .frame(height: 96)
                .padding([.top, .bottom])
            }
            if plotData.isEmpty {
                Text("Selecciona categoría para mostrar")
            } else {
                Chart {
                    ForEach(plotData, id: \.self) { data in
                        let dataColor = Color.random()
                        ForEach(data.valores, id: \.self) { valor in
                            BarMark(
                                x: .value("Date", data.date.getMonthTitle()),
                                y: .value(valor.title, valor.valor)
                                      )
                            .cornerRadius(8)
                            .foregroundStyle(valor.color)
                            //.position(by: .value(valor.title, valor.valor)) Para compararlos uno al lado del otro
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
    }
}
