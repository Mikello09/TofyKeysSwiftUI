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
    
}
