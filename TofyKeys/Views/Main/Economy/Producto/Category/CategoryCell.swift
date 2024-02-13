//
//  CategoryCell.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 9/2/24.
//

import SwiftUI

struct CategoryCell: View {
    
    var item: CategoriaItem
    var category: Category
    @Binding var detailedCategories: [Category]
    
    var body: some View {
        VStack {
            Button {
                if detailedCategories.contains(where: {$0.id == category.id}) {
                    detailedCategories.removeAll(where: {$0.id == category.id})
                } else {
                    detailedCategories.append(category)
                }
            } label: {
                VStack {
                    HStack {
                        Image(systemName: category.image)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.blackTofy)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 8)
                        Text(category.title)
                            .font(Font.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.primaryColor)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 8) {
                            Text(item.value.toCurrency())
                                .font(Font.system(size: 14, weight: .semibold))
                                .foregroundStyle(item.value >= 0 ? .green : .red)
                            HStack {
                                if item.numericalComparison > 0 {
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .foregroundStyle(.green)
                                } else if item.numericalComparison == 0 {
                                    Image(systemName: "equal")
                                        .foregroundStyle(.gray)
                                } else {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .foregroundStyle(.red)
                                }
                                Text("\(item.numericalComparison.roundedTo2Decimals())")
                                    .font(Font.system(size: 14, weight: .semibold))
                                    .foregroundStyle(item.numericalComparison >= 0 ? .green : .red)
                            }
                        }
                    }
                    if detailedCategories.contains(where: {$0.id == category.id}) {
                        VStack(spacing: 16) {
                            ForEach(item.transactions) { transaction in
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(transaction.titulo)
                                            .font(Font.system(size: 14, weight: .semibold))
                                            .foregroundStyle(Color.primaryColor)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 8) {
                                        Text(transaction.valor.toCurrency())
                                            .font(Font.system(size: 14, weight: .semibold))
                                            .foregroundStyle(transaction.tipo == "ingreso" ? .green : .red)
                                        Text(transaction.fecha.toDayString())
                                            .font(Font.system(size: 12, weight: .regular))
                                            .foregroundStyle(Color.secondaryColor)
                                    }
                                }
                                if transaction != item.transactions.last {
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.categoryDetailBackground)
                        }
                    }
                }
            }
        }
    }
}
