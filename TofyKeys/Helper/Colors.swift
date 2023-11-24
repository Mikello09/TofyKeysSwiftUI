//
//  Colors.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import SwiftUI



extension Color{
    public static let primaryColor: Color = Color(.primaryColor)
    public static let secondaryColor: Color = Color(.secondaryColor)
    public static let primaryColorHighlighted: Color = Color(.primaryColorHighlighted)
    public static let whiteHighlighted: Color = Color(.whiteHighlighted)
    public static let blackTofy: Color = Color(.blackTofy)
    public static let screenBackground: Color = Color(.screenBackground)
    public static let redTofy: Color = Color(.redTofy)
    public static let screenBackgroundDark: Color = Color(.screenBackgroundDark)
    public static let dismissColor: Color = Color(.dismissColor)
    public static let elementColor: Color = Color(.elementColor)
    public static let primaryText: Color = Color("PrimaryText", bundle: nil)
    // CELLS
    public static let claveCellColor: Color = Color(.claveCellColor)
    public static let selectedClaveCells: Color = Color(.selectedClaveCells)
}

extension UIColor{
    public static let primaryColor: UIColor = UIColor.init(named: "PrimaryColor")!
    public static let secondaryColor: UIColor = UIColor.init(named: "SecondaryColor")!
    public static let primaryColorHighlighted: UIColor = UIColor.init(named: "PrimaryColorHighlighted")!
    public static let whiteHighlighted: UIColor = UIColor.init(named: "WhiteHighlighted")!
    public static let blackTofy: UIColor = UIColor.init(named: "BlackTofy")!
    public static let screenBackground: UIColor = UIColor.init(named: "ScreenBackground")!
    public static let redTofy: UIColor = UIColor.init(named: "RedTofy")!
    public static let screenBackgroundDark: UIColor = UIColor.init(named: "ScreenBackgroundDark")!
    public static let dismissColor: UIColor = UIColor.init(named: "DismissColor")!
    public static let elementColor: UIColor = UIColor.init(named: "ElementBackground")!
    // CELLS
    public static let claveCellColor: UIColor = UIColor.init(named: "ClaveCells")!
    public static let selectedClaveCells: UIColor = UIColor.init(named: "SelectedClaveCells")!
}
