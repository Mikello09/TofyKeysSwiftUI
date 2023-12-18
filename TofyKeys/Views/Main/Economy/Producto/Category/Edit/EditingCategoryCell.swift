//
//  EditingCategoryCell.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 18/12/23.
//

import Foundation
import SwiftUI


struct EditingCategoryCell: View {
    
    var symbols: [String: SymbolCategory]
    var category: Category
    
    @State var editedCategoryTitle: String = ""
    @State var editedCategoryImage: String = ""
    @State var symbolCategory: SymbolCategory = .comunicacion
    
    var onClose: ((_: String?, _: String?) -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            onClose(nil, nil)
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            onClose(editedCategoryTitle, editedCategoryImage)
                        }
                    } label: {
                        Text("Guardar")
                            .font(Font.system(size: 13, weight: .semibold))
                    }
                }
                .padding(.bottom)
                TofyTextField(text: $editedCategoryTitle, title: "Título de categoría")
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
                    Image(systemName: editedCategoryImage)
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
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: proxy.size.width/5 - 12, height: proxy.size.width/5 - 12)
                                .background(editedCategoryImage == image ? .green : .clear)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray, lineWidth: 2)
                                        
                                )
                                .onTapGesture {
                                    editedCategoryImage = image
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(height: 200)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
        }
        .padding([.leading, .trailing])
        .padding(.top, 6)
        .onAppear {
            editedCategoryTitle = category.title
            editedCategoryImage = category.image
        }
    }
}
