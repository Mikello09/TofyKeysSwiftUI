//
//  BottomSheetView.swift
//  TofyKeys
//
//  Created by Mikel on 28/4/22.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = 0//maxHeight * 0.7
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius:  8)
            .fill(Color.black)
            .frame(width: 120, height: 4)
    }
    
    @GestureState private var translation: CGFloat = 0
    
    // Caution!!! Only show Bottom Sheet if isOpen is true
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
            .background(Color.blue)
            .cornerRadius(8)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: isOpen ? max(self.offset +  self.translation, 0) : maxHeight)
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    if isOpen {
                        let snapDistance = self.maxHeight * 0.5
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }
                        self.isOpen = value.translation.height < 0
                    }
                }
            )
        }
    }
}
