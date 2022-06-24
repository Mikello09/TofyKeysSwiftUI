//
//  BottomSheetView.swift
//  TofyKeys
//
//  Created by Mikel on 28/4/22.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    @Binding var isOpen: Bool
    @Binding var claveType: ClaveType
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, claveType: Binding<ClaveType>, @ViewBuilder content: () -> Content) {
        self.minHeight = 0
        self.maxHeight = maxHeight
        self._claveType = claveType
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
            .frame(width: geometry.size.width, height: claveType == .value ? 450 : maxHeight, alignment: .top)
            .background(Color.white)
            .cornerRadius(8)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: isOpen ? max(self.offset + self.translation, 0) : maxHeight)
            .shadow(radius: 2)
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .animation(.interactiveSpring(), value: claveType)
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
