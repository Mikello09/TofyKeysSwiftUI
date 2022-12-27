//
//  Animations.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/12/22.
//

import Foundation
import SwiftUI

struct SelectedAnimation {
    @Binding var colorToChange: Color
    
    func animate(from: Color, to: Color, duration: CGFloat = 0.3) {
        withAnimation(.linear(duration: duration)) {
            colorToChange = to
        }
        withAnimation(.linear(duration: duration).delay(duration)) {
            colorToChange = from
        }
    }
}
