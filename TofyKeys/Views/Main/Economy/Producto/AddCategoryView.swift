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
    @Binding var isShowing: Bool
    
    var categoryAdded: ((Category) -> Void)
    
    var body: some View {
        VStack(spacing: 24) {
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
                            categoryAdded(Category(id: id, image: Image(systemName: categoryImage), title: titulo))
                            isShowing = false
                        }
                    }, label: {
                        TextButton(text: "Añadir")
                    })
                    .padding()
                }
            }
            
            TextField("Título", text: $titulo)
                .padding([.leading, .trailing])
            GeometryReader { proxy in
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(getAllCategoryImages(), id: \.self) { image in
                        VStack(spacing: 8) {
                            Image(systemName: image)
                        }
                        .frame(width: proxy.size.width/5 - 8, height: proxy.size.width/5 - 8)
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
    
    func getAllCategoryImages() -> [String] {
        return ["house.fill",
                "lamp.table.fill",
                "web.camera.fill",
                "door.left.hand.closed",
                "spigot.fill",
                "shower.fill",
                "bathtub.fill",
                "pipe.and.drop.fill",
                "videoprojector.fill",
                "wifi.router.fill",
                "party.popper.fill",
                "balloon.fill",
                "frying.pan.fill",
                "popcorn.fill",
                "bed.double.fill",
                "sofa.fill",
                "chair.lounge.fill",
                "fireplace.fill",
                "washer.fill",
                "refrigerator.fill",
                "sink.fill",
                "toilet.fill",
                "stairs"]
    }
}

