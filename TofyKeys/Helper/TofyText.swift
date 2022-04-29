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
    
    func title() -> some View {
        self.foregroundColor(.blackTofy)
            .font(.system(size: 18, weight: .semibold))
    }
    
    func subtitle() -> some View {
        self.foregroundColor(.blackTofy)
            .font(.system(size: 16, weight: .regular))
    }
    
    func errorMessage() -> some View {
        self.foregroundColor(.redTofy)
            .font(.system(size: 14, weight: .semibold))
    }
}
