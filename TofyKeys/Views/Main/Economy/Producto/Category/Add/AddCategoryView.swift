//
//  AddCategoryView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 3/8/23.
//

import SwiftUI

struct AddCategoryView: View {
    
    @ObservedObject var categoryViewModel: TransactionCategoryViewModel
    
    @State var titulo: String = ""
    @State var categoryImage: String = ""
    @State private var symbolCategory: SymbolCategory = .comunicacion
    @State private var symbols: [String: SymbolCategory] = [:]
    @Binding var isShowing: Bool
    
    var categoryAdded: ((Category) -> Void)
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Text("Crea tu categoría")
                    Spacer()
                }
                .padding()
                HStack {
                    Spacer()
                    Button (action: {
                        if titulo != "" && categoryImage != "" {
                            let id = UUID()
                            categoryViewModel.addCategory(id: id, titulo: titulo, image: categoryImage)
                            categoryAdded(Category(id: id, image: categoryImage, title: titulo))
                            isShowing = false
                        }
                    }, label: {
                        TextButton(text: "Añadir")
                    })
                    .padding()
                }
            }
            .padding()
            
            TofyTextField(text: $titulo, title: "Título")
                .padding([.leading, .trailing])
            HStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Busca la imagen para la categoría:")
                            .font(Font.system(size: 14))
                            .padding(.leading)
                        Spacer()
                    }
                    HStack {
                        Picker("", selection: $symbolCategory) {
                            ForEach(SymbolCategory.allCases, id: \.self) { category in
                                Text(category.getTitle()).tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.leading)
                        Spacer()
                    }
                }
                Spacer()
                Image(systemName: categoryImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .padding(.trailing)
                Spacer()
            }
            .padding([.top, .trailing])
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(symbols.filter({ $0.value == symbolCategory }).compactMap({ $0.key }), id: \.self) { image in
                            VStack(spacing: 8) {
                                Image(systemName: image)
                            }
                            .frame(width: proxy.size.width/5 - 12, height: proxy.size.width/5 - 12)
                            .background(categoryImage == image ? .green : .clear)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray, lineWidth: 2)
                                    
                            )
                            .onTapGesture {
                                categoryImage = image
                            }
                        }
                    }
                    .padding()
                }
                
            }
        }
        .onAppear {
            symbols = SFSymbolManager.getAllCategoryImages()
        }
    }
}

