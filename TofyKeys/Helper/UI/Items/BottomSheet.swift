//
//  BottomSheetView.swift
//  TofyKeys
//
//  Created by Mikel on 28/4/22.
//

import SwiftUI
import Combine

struct BottomSheetView<Content: View>: View {
    
    @Binding var isOpen: Bool
    @Binding var claveType: ClaveType
    var onClose: (() -> Void)
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    @State var keyboardHeight: CGFloat = 0
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, claveType: Binding<ClaveType>, onClose: @escaping(()->Void), @ViewBuilder content: () -> Content) {
        self.minHeight = 0
        self.maxHeight = maxHeight
        self._claveType = claveType
        self.content = content()
        self._isOpen = isOpen
        self.onClose = onClose
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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                indicator.padding()
                content
            }
            .frame(width: geometry.size.width, height: keyboardHeight/2 + (isOpen ? claveType.getHeight() : 0), alignment: .top)
            .background(Color.white)
            .cornerRadius(8)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: isOpen ? max(self.offset + translation, 0) : maxHeight)
            .shadow(radius: 2)
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .animation(.interactiveSpring(), value: claveType)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    if isOpen {
                        let snapDistance = maxHeight * 0.5
                        guard abs(value.translation.height) > snapDistance else {
                            return
                        }
                        isOpen = value.translation.height < 0
                        if !isOpen {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            onClose()
                        }
                    }
                }
            )
            .onReceive(keyboardPublisher) { keyboardHeight in
                self.keyboardHeight = keyboardHeight
                print("Keyboard height: \(keyboardHeight)")
            }
        }
    }
}


extension View {
  var keyboardPublisher: AnyPublisher<CGFloat, Never> {
      Publishers.Merge(
                  NotificationCenter.default
                      .publisher(for: UIResponder.keyboardWillShowNotification)
                      .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                      .map {
                          $0.cgRectValue.height
                      },
                  NotificationCenter.default
                      .publisher(for: UIResponder.keyboardWillHideNotification)
                      .map { _ in CGFloat(0) }
             ).eraseToAnyPublisher()
  }
}
