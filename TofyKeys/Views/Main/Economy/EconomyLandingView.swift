//
//  EconomyLandingView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/3/23.
//

import Foundation
import SwiftUI

struct EconomyLandingView: View {
    
    @ObservedObject var economyViewModel: EconomyViewModel
    
    @State var periodoActivo: Periodo?
    
    @State var addPeriodoSheet: Bool = false
    @State var addIngresoGasto: Bool = false
    
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
                                            addIngresoGasto = true
                                        } label: {
                                            TextButton(text: "Añadir")
                                        }
                                    }
                                    .padding()
                                    Spacer()
                                }
                                if periodoActivo.tipo == "manual" {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Button {
                                                print("Añadir ingreso/gasto")
                                            } label: {
                                                TextButton(text: "Cerrar periodo", foregroundColor: .redTofy, size: 14)
                                            }
                                        }
                                        .padding()
                                    }
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
                                }
                                .padding()
                            }
                            
                            
                        } else {
                            Text("No hay periodos activos. Añade un periodo")
                        }
                    }
                    .frame(height: 200)
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
                AddTransferPeriodoView(onAdd: onAddGastoIngreso)
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
    
    func onAddGastoIngreso(titulo: String, tipo: String, valor: Double) {
        addIngresoGasto = false
        economyViewModel.addGasto(titulo: titulo, tipo: tipo, valor: valor)
    }
    
    func addCuenta() {
        
    }
    
    func addPresupuesto() {
        
    }
}
