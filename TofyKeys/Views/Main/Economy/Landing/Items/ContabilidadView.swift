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
                            VStack {
                                Text(Date().getMonthTitle().capitalized)
                                    .font(Font.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.primaryText)
                                Text(producto.fechaInicio.daysFrom())
                                    .font(Font.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.primaryText)
                            }
                        }
                        Spacer()
                        HStack {
                            Chart {
                                BarMark(x: .value("Gngresos", "Ingresos"),
                                        y: .value("Ingresos", producto.getIngresos()),
                                width: 56)
                                .annotation(position: .top) {
                                    Text(producto.getIngresos().toCurrency())
                                        .font(Font.system(size: 10, weight: .semibold))
                                        .foregroundStyle(Color.primaryText)
                                }
                                .cornerRadius(8)
                                .foregroundStyle(.linearGradient(colors: [Color.green.opacity(0.5), Color.green], startPoint: .bottom, endPoint: .top))
                                BarMark(x: .value("Gastos", "Gastos"),
                                        y: .value("Gastos", producto.getGastos()),
                                width: 56)
                                .annotation(position: .top) {
                                    Text(producto.getGastos().toCurrency())
                                        .font(Font.system(size: 10, weight: .semibold))
                                        .foregroundStyle(Color.primaryText)
                                }
                                .cornerRadius(8)
                                .foregroundStyle(.linearGradient(colors: [Color.redTofy.opacity(0.5), Color.redTofy], startPoint: .bottom, endPoint: .top))
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                            .frame(width: 128)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Text("Disponible")
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
