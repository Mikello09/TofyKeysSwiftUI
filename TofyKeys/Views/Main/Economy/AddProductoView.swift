//
//  AddPeriodoView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 25/6/23.
//

import Foundation
import SwiftUI

struct AddProductoView: View {
    
    @State var titulo: String = ""
    @State var tipo: TipoProducto = TipoProducto.contabilidad
    @State var valorInicial: String = ""
    
    var producto: TipoProducto
    
    var onAdd: ((String, TipoProducto, String) -> Void)
    
    var body: some View {
        
        VStack(spacing: 24) {
            ZStack {
                switch producto {
                case .contabilidad:
                    Text("Contabilidad")
                case .cuenta:
                    Text("Cuenta")
                case .presupuesto:
                    Text("Presupuesto")
                case .gastos:
                    Text("Gastos")
                }
                HStack {
                    Spacer()
                    Button (action: {
                        if !titulo.isEmpty {
                            if producto != .contabilidad {
                                onAdd(titulo, producto, valorInicial)
                            } else {
                                onAdd(titulo, tipo, valorInicial)
                            }
                        }
                    }, label: {
                        TextButton(text: "Añadir")
                    })
                    .padding()
                }
            }
            switch producto {
            case .contabilidad:
                Text("Contabiliza todos los gastos e ingresos durante un periodo de tiempo. Este producto es ideal para llevar los gastos de cadad mes. También se puede utilizar para un periodo anual o de temporada.")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            case .cuenta:
                Text("Crea un producto de cuenta de ahorros, de gastos o con cualquier otro objetivo. Podrás modificar el saldo en cualquier momento y tendrás acceso al histórico para saber como se ha ido evolucionando.\n\nAdemás, podrás definir esta cuenta para poder añadir automaticamente resultados de otros productos como una contabilidad.")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            case .presupuesto:
                Text("¿Tienes un dinero presupuestado con un objetivo? Anótalo en este producto y podrás ir viendo cuanto presupuesto te va quedando a lo largo del tiempo. También podrás ampliarlo en caso de que lo necesites.")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            case .gastos:
                Text("¿Te vas de viaje? Ánota todos tus gastos en este producto y luego añádelos de forma agrupada a una contabilidad o cuenta.")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            TextField("Título", text: $titulo)
            switch producto {
            case .contabilidad:
                Picker(selection: $tipo, label: Text("Forma de creación")) {
                    Text("Manual").tag(TipoProducto.contabilidad)
                    Text("Mensual").tag(TipoProducto.contabilidad)
                }
                .pickerStyle(SegmentedPickerStyle())
                HStack {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Termina el periodo cuando tú quieras.")
                    Spacer()
                }
            case .cuenta:
                TextField("Valor inicial", text: $valorInicial)
                    .keyboardType(.decimalPad)
            case .presupuesto:
                TextField("Valor inicial", text: $valorInicial)
                    .keyboardType(.decimalPad)
            case .gastos:
                EmptyView()
            }
            Spacer()
        }
        .padding()
        
    }
    
}
