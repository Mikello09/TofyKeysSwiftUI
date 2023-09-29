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
    @State var productos: [Periodo] = []
    @State var productosVacios: [TipoProducto] = []
    
    @State var addContabilidadSheet: Bool = false
    @State var addCuentaSheet: Bool = false
    @State var addPresupuestoSheet: Bool = false
    @State var addGastosSheet: Bool = false
    
    @State var addIngresoGasto: Bool = false
    @State var showPeriodoDetalle: Bool = false
    @State var closePeriodo: Bool = false

    @State var selectedCuenta: Periodo?
    @State var showCuentaDetail: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            TofyNavigation {
            
                ZStack {
                    ScrollView {
                        VStack {
                            Contabilidad(periodoActivo: $periodoActivo,
                                         addIngresoGasto: $addIngresoGasto,
                                         showPeriodoDetalle: $showPeriodoDetalle,
                                         closePeriodo: $closePeriodo)
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
                                        ForEach(self.productos, id: \.self) { producto in
                                            if producto.tipo == TipoProducto.cuenta.rawValue {
                                                CuentaView(cuenta: producto)
                                                    .frame(width: proxy.size.width/2 - 32,
                                                           height: proxy.size.width/2 - 32)
                                                    .onTapGesture {
                                                        selectedCuenta = producto
                                                        showCuentaDetail = true
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
                    .sheet(isPresented: $addContabilidadSheet, content: {
                        AddProductoView(producto: .contabilidadManual ,onAdd: onAddPeriodo)
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
                    .sheet(isPresented: $addIngresoGasto, content: {
                        AddTransferPeriodoView(categoryViewModel: categoryViewModel,
                                               onAdd: onAddGastoIngreso)
                    })
                    if closePeriodo {
                        ClosePeriodoPopup() {
                            economyViewModel.closePeriodoActivo()
                            closePeriodo = false
                        }
                        .padding()
                    }
                }
                .toolbar(content: {
                    Menu {
                        Button("Contabilidad", action: addPeriodo)
                        Button("Cuenta", action: addCuenta)
                        Button("Presupuesto", action: addPresupuesto)
                        Button("Anotar Gastos", action: addAnotarGastos)
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
                .navigationDestination(isPresented: $showCuentaDetail) {
                    if let selectedCuenta {
                        PeriodoDetalleView(economyViewModel: economyViewModel, categoryViewModel: categoryViewModel, periodo: selectedCuenta)
                    }
                }
            }
        }
        .onAppear {
            economyViewModel.getPeriodoActivo()
            economyViewModel.getProductos()
        }
        .onReceive(economyViewModel.$periodoActivo) { periodoActivo in
            self.periodoActivo = periodoActivo
        }
        .onReceive(economyViewModel.$productos) { productos in
            self.productos = productos
            productosVacios = [.cuenta, .gastos, .presupuesto]
        }
    }
}

// MARK: ADD ACTIONS
extension EconomyLandingView {
    func addPeriodo() {
        if periodoActivo == nil {
            addContabilidadSheet = true
        }
    }
    
    func onAddPeriodo(titulo: String, tipo: TipoProducto, valorInicial: String) {
        addContabilidadSheet = false
        addCuentaSheet = false
        addPresupuestoSheet = false
        addGastosSheet = false
        
        economyViewModel.addPeriodo(titulo: titulo, tipo: tipo, valorInicial: valorInicial)
    }
    
    func onAddGastoIngreso(titulo: String, tipo: String, valor: Double, category: UUID, observacion: String) {
        if let periodoActivo {
            addIngresoGasto = false
            economyViewModel.addTransaction(periodo: periodoActivo, titulo: titulo, tipo: tipo, valor: valor, category: category, observacion: observacion)
        }
    }
    
    func addCuenta() {
        addCuentaSheet = true
    }
    
    func addPresupuesto() {
        addPresupuestoSheet = true
    }
    
    func addAnotarGastos() {
        addGastosSheet = true
    }
}

// MARK: CONTABILIDAD VIEW
struct Contabilidad: View {
    
    @Binding var periodoActivo: Periodo?
    @Binding var addIngresoGasto: Bool
    @Binding var showPeriodoDetalle: Bool
    @Binding var closePeriodo: Bool
    
    var body: some View {
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
                                    BarMark(x: .value("Gastos", periodoActivo.getGastos()),
                                            y: .value("Gastos", "Gastos"))
                                    .foregroundStyle(Color.redTofy)
                                    BarMark(x: .value("Ingresos", periodoActivo.getIngresos()),
                                            y: .value("Gngresos", "Ingresos"))
                                    .foregroundStyle(Color.green)
                                }
                                .chartXAxis(.hidden)
                                .chartYAxis {
                                    AxisMarks(position: .leading) { value in
                                        if let value = value.as(String.self) {
                                            if value == "Gastos" {
                                                AxisValueLabel {
                                                    Text("Gastos \(periodoActivo.getGastos().toCurrency())")
                                                }
                                            } else {
                                                AxisValueLabel {
                                                    Text("Ingresos \(periodoActivo.getIngresos().toCurrency())")
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
                                if periodoActivo.tipo == "contabilidadManual" {
                                    Button {
                                        closePeriodo = true
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
    }
}


// MARK: CUENTA VIEW
struct CuentaView: View {
    
    var cuenta: Periodo?
    
    var body: some View {
        if let cuenta {
            VStack(spacing: 16) {
                Spacer()
                HStack {
                    Spacer()
                    Text(cuenta.titulo)
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
    
    var gasto: Periodo?
    
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
    
    var presupuesto: Periodo?
    
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
