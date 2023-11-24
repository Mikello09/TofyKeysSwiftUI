//
//  ContabilidadView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 24/11/23.
//

import Foundation
import SwiftUI
import Charts

struct ContabilidadView: View {
    
    @State var producto: Producto
    @Binding var addIngresoGasto: Bool
    @Binding var showPeriodoDetalle: Bool
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text(producto.titulo)
                                .font(Font.system(size: 20, weight: .bold))
                            Spacer()
                        }
                        HStack {
                            Text(Date().getMonthTitle().capitalized)
                            Text(producto.fechaInicio.daysFrom())
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Chart {
                                BarMark(x: .value("Gastos", producto.getGastos()),
                                        y: .value("Gastos", "Gastos"))
                                .foregroundStyle(Color.redTofy)
                                BarMark(x: .value("Ingresos", producto.getIngresos()),
                                        y: .value("Gngresos", "Ingresos"))
                                .foregroundStyle(Color.green)
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis {
                                AxisMarks(position: .leading) { value in
                                    if let value = value.as(String.self) {
                                        if value == "Gastos" {
                                            AxisValueLabel {
                                                Text("Gastos \(producto.getGastos().toCurrency())")
                                            }
                                        } else {
                                            AxisValueLabel {
                                                Text("Ingresos \(producto.getIngresos().toCurrency())")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                        HStack {
                            Text("Restante")
                            Text("\(producto.getIngresosGastosDifference().toCurrency())")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                    }
                    .padding()
                }
                
            }
            .frame(height: 250)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}
