//
//  TextExtension.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import SwiftUI


extension Text {
    
    func appTitle() -> some View {
        self.foregroundColor(.black)
            .font(.largeTitle)
    }
    
    func title(_ color: Color = Color.blackTofy) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 22, weight: .bold))
    }
    
    func subtitle() -> some View {
        self.foregroundColor(.blackTofy)
            .font(.system(size: 18, weight: .regular))
    }
    
    func errorMessage() -> some View {
        self.foregroundColor(.redTofy)
            .font(.system(size: 14, weight: .semibold))
    }
}
