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
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var productos: [Producto] = []
    @State var productosVacios: [TipoProducto] = []
    
    @State var addContabilidadSheet: Bool = false
    @State var addCuentaSheet: Bool = false
    @State var addPresupuestoSheet: Bool = false
    @State var addGastosSheet: Bool = false
    
    @State var addIngresoGasto: Bool = false
    @State var showPeriodoDetalle: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            TofyNavigation {
                ZStack {
                    if productos.isEmpty {
                        EconomyEmptyState(geometry: proxy) { producto in
                            switch producto {
                            case .contabilidad: addContabilidadSheet = true
                            case .cuenta: addCuentaSheet = true
                            case .presupuesto: addPresupuestoSheet = true
                            case .gastos: addGastosSheet = true
                            }
                        }
                    } else {
                        ZStack {
                            ScrollView {
                                VStack {
                                    ForEach(productos.filter({ $0.tipo == TipoProducto.contabilidad.rawValue }), id: \.self) { producto in
                                        NavigationLink {
                                            ProductoDetalleView(economyViewModel: economyViewModel, categoryViewModel: categoryViewModel, producto: producto)
                                        } label: {
                                            ContabilidadView(producto: producto,
                                                         addIngresoGasto: $addIngresoGasto,
                                                         showPeriodoDetalle: $showPeriodoDetalle)
                                        }
                                    }
                                    .padding()
                                    VStack {
                                        if self.productos.isEmpty {
                                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 8) {
                                                ForEach(self.productosVacios, id: \.self) { producto in
                                                    switch producto {
                                                    case .cuenta:
                                                        VStack {
                                                            Spacer()
                                                            CuentaView(cuenta: nil)
                                                                .frame(width: proxy.size.width/2 - 32, height: proxy.size.width/2 - 32)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                                                }
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            addCuentaSheet = true
                                                        }
                                                    case .gastos:
                                                        VStack {
                                                            Spacer()
                                                            GastoView(gasto: nil)
                                                                .frame(width: proxy.size.width/2 - 32, height: proxy.size.width/2 - 32)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                                                }
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            addGastosSheet = true
                                                        }
                                                    case .presupuesto:
                                                        VStack {
                                                            Spacer()
                                                            PresupuestView(presupuesto: nil)
                                                                .frame(width: proxy.size.width/2 - 32, height: proxy.size.width/2 - 32)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                                                }
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            addPresupuestoSheet = true
                                                        }
                                                    default:
                                                        EmptyView()
                                                    }
                                                }
                                            }
                                            .padding()
                                        } else {
                                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 8) {
                                                ForEach(self.productos.filter({ $0.tipo != TipoProducto.contabilidad.rawValue }), id: \.self) { producto in
                                                    if producto.tipo == TipoProducto.cuenta.rawValue {
                                                        NavigationLink {
                                                            ProductoDetalleView(economyViewModel: economyViewModel, categoryViewModel: categoryViewModel, producto: producto)
                                                        } label: {
                                                            CuentaView(cuenta: producto)
                                                                .frame(width: proxy.size.width/2 - 32,
                                                                       height: proxy.size.width/2 - 32)
                                                        }

                                                        
                                                        
                                                    } else {
                                                        Text(producto.tipo)
                                                    }
                                                }
                                            }
                                            .padding()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $addContabilidadSheet, content: {
                    AddProductoView(producto: .contabilidad ,onAdd: onAddPeriodo)
                })
                .sheet(isPresented: $addCuentaSheet, content: {
                    AddProductoView(producto: .cuenta ,onAdd: onAddPeriodo)
                })
                .sheet(isPresented: $addPresupuestoSheet, content: {
                    AddProductoView(producto: .presupuesto ,onAdd: onAddPeriodo)
                })
                .sheet(isPresented: $addGastosSheet, content: {
                    AddProductoView(producto: .gastos ,onAdd: onAddPeriodo)
                })
                .toolbar(content: {
                    Menu {
                        Button("Contabilidad", action: { addContabilidadSheet = true })
                        Button("Cuenta", action: { addCuentaSheet = true })
                        Button("Presupuesto", action: { addPresupuestoSheet = true })
                        Button("Anotar Gastos", action: { addGastosSheet = true })
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .foregroundColor(.primaryColor)
                    .font(Font.system(size: 18, weight: .semibold))
                    
                })
                .navigationTitle(productos.isEmpty ? "" : "Economy")
            }
        }
        .onAppear {
            economyViewModel.getProductos()
        }
        .onReceive(economyViewModel.$productos) { productos in
            self.productos = productos
            productosVacios = [.cuenta, .gastos, .presupuesto]
        }
    }
}

// MARK: ADD ACTIONS
extension EconomyLandingView {
    func onAddPeriodo(titulo: String, tipo: TipoProducto, valorInicial: String) {
        addContabilidadSheet = false
        addCuentaSheet = false
        addPresupuestoSheet = false
        addGastosSheet = false
        
        economyViewModel.addProducto(titulo: titulo, tipo: tipo, valorInicial: valorInicial)
    }
}

// MARK: EMPTY STATE
struct EconomyEmptyState: View {
    
    var geometry: GeometryProxy
    var completion: ((TipoProducto) -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Lleva el control de tus finanzas")
                .font(Font.system(size: 36, weight: .bold))
                .multilineTextAlignment(.leading)
            Text("Empieza a añadir tus productos")
                .font(Font.system(size: 17, weight: .semibold))
                .padding(.top)
            Spacer()
            LazyVGrid(columns: [GridItem(.fixed((geometry.size.width/2) - 32)), GridItem(.fixed((geometry.size.width/2) - 32))], content: {
                ForEach(TipoProducto.allCases, id: \.self) { producto in
                    Button(action: {
                        completion(producto)
                    }, label: {
                        VStack(spacing: 8) {
                            producto.getImage()
                                .resizable()
                                .frame(width: 48, height: 48)
                            Text(producto.getTitle())
                                .font(Font.system(size: 21, weight: .bold))
                                .foregroundStyle(Color.primaryText)
                            Spacer()
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Ejemplo")
                                        .font(Font.system(size: 11))
                                        .foregroundStyle(Color.primaryText)
                                    Spacer()
                                }
                                HStack {
                                    Text(producto.getExample())
                                        .multilineTextAlignment(.leading)
                                        .font(Font.system(size: 14, weight: .bold))
                                        .foregroundStyle(Color.primaryText)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.cyan)
                        }
                        .frame(width: (geometry.size.width/2) - 32, height: (geometry.size.width/2) + 48)
                    })
                }
            })
            Spacer()
        }
        .padding([.leading, .trailing])
    }
}
// MARK: CUENTA VIEW
struct CuentaView: View {
    
    var cuenta: Producto?
    
    var body: some View {
        if let cuenta {
            VStack(spacing: 16) {
                Spacer()
                HStack {
                    Spacer()
                    Text(cuenta.titulo)
                        .foregroundStyle(.black)
                        .padding([.leading, .trailing], 24)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(cuenta.getIngresosGastosDifference().toCurrency())
                        .padding([.leading, .trailing], 24)
                    Spacer()
                }
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        } else {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "banknote")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                Text("Añade una cuenta")
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding([.leading, .trailing], 24)
                Spacer()
            }
            
        }
    }
}

// MARK: GASTO VIEW
struct GastoView: View {
    
    var gasto: Producto?
    
    var body: some View {
        if let gasto {
            VStack {
                Text(gasto.titulo)
                Text("\(gasto.getIngresosGastosDifference())")
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        } else {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "creditcard.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                Text("Añade un gasto")
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding([.leading, .trailing], 24)
                Spacer()
            }
            
        }
    }
}

struct PresupuestView: View {
    
    var presupuesto: Producto?
    
    var body: some View {
        if let presupuesto {
            VStack {
                Text(presupuesto.titulo)
            }
        } else {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "basket.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                Text("Añade un presupuesto")
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding([.leading, .trailing], 24)
                Spacer()
            }
            
        }
    }
}
