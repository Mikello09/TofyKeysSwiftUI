//
//  EconomyLandingView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/3/23.
//

import Foundation
import SwiftUI
import Charts

struct EconomyLandingView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var periodoActivo: Periodo?
    
    @State var addPeriodoSheet: Bool = false
    @State var addIngresoGasto: Bool = false
    @State var showPeriodoDetalle: Bool = false
    
    var body: some View {
        TofyNavigation {
            VStack {
                VStack {
                    VStack {
                        if let periodoActivo {
                            ZStack {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            showPeriodoDetalle = true
                                        } label: {
                                            TextButton(text: "Detalle", foregroundColor: .blue)
                                        }
                                        Button {
                                            addIngresoGasto = true
                                        } label: {
                                            TextButton(text: "Añadir")
                                        }
                                    }
                                    .padding()
                                    Spacer()
                                }
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(periodoActivo.titulo)
                                            .font(Font.system(size: 20, weight: .bold))
                                        Spacer()
                                    }
                                    HStack {
                                        Text(periodoActivo.fechaInicio.daysFrom())
                                        Spacer()
                                    }
                                    Spacer()
                                    HStack {
                                        Chart {
                                            BarMark(x: .value("Gastos", periodoActivo.getGastosValue()),
                                                    y: .value("Gastos", "Gastos"))
                                            .foregroundStyle(Color.redTofy)
                                            BarMark(x: .value("Ingresos", periodoActivo.getIngresosValue()),
                                                    y: .value("Gngresos", "Ingresos"))
                                            .foregroundStyle(Color.green)
                                        }
                                        .chartXAxis(.hidden)
                                        .chartYAxis {
                                            AxisMarks(position: .leading) { value in
                                                if let value = value.as(String.self) {
                                                    if value == "Gastos" {
                                                        AxisValueLabel {
                                                            Text("Gastos \(periodoActivo.getGastosValue().toCurrency())")
                                                        }
                                                    } else {
                                                        AxisValueLabel {
                                                            Text("Ingresos \(periodoActivo.getIngresosValue().toCurrency())")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                    HStack {
                                        Text("Restante")
                                        Text("\(periodoActivo.getIngresosGastosDifference().toCurrency())")
                                            .fontWeight(.semibold)
                                        Spacer()
                                        if periodoActivo.tipo == "manual" {
                                            Button {
                                                print("Añadir ingreso/gasto")
                                            } label: {
                                                TextButton(text: "Cerrar periodo", foregroundColor: .redTofy, size: 14)
                                            }
                                        }
                                    }
                                    
                                }
                                .padding()
                            }
                        } else {
                            HStack {
                                Spacer()
                                Text("No hay periodos activos. Añade un periodo")
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 250)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding()
                Spacer()
            }
            .sheet(isPresented: $addPeriodoSheet, content: {
                AddPeriodoView(onAdd: onAddPeriodo)
            })
            .sheet(isPresented: $addIngresoGasto, content: {
                AddTransferPeriodoView(categoryViewModel: categoryViewModel,
                                       onAdd: onAddGastoIngreso)
            })
            .toolbar(content: {
                Menu {
                    Button("Periodo", action: addPeriodo)
                    Button("Cuenta", action: addCuenta)
                    Button("Presupuesto", action: addPresupuesto)
                } label: {
                    Image(systemName: "plus.circle")
                }
                .foregroundColor(.primaryColor)
                .font(Font.system(size: 18, weight: .semibold))
                
            })
            .navigationTitle("Economy")
            .navigationDestination(isPresented: $showPeriodoDetalle) {
                if let periodoActivo {
                    PeriodoDetalleView(economyViewModel: economyViewModel, categoryViewModel: categoryViewModel, periodo: periodoActivo)
                }
            }
        }
        .onAppear {
            economyViewModel.getPeriodoActivo()
        }
        .onReceive(economyViewModel.$periodoActivo) { periodoActivo in
            if let periodoActivo {
                self.periodoActivo = periodoActivo
            }
        }
    }
}

// MARK: ADD ACTIONS
extension EconomyLandingView {
    func addPeriodo() {
        if periodoActivo == nil {
            addPeriodoSheet = true
        }
    }
    
    func onAddPeriodo(titulo: String, tipo: String) {
        addPeriodoSheet = false
        economyViewModel.addPeriodo(titulo: titulo, tipo: tipo)
    }
    
    func onAddGastoIngreso(titulo: String, tipo: String, valor: Double, category: UUID, observacion: String) {
        addIngresoGasto = false
        economyViewModel.addTransaction(titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion)
    }
    
    func addCuenta() {
        
    }
    
    func addPresupuesto() {
        
    }
}
