//
//  LocalizableHelper.swift
//  TofyKeys
//
//  Created by Mikel on 28/3/22.
//

import Foundation
import SwiftUI


extension String {
    var localized: String {
        
        return LocalizedStringKey(self)
//        if let path = Bundle.main.path(forResource: Locale.current.languageCode, ofType: "lproj"){
//            if let bundle = Bundle(path: path) {
//                return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
//            }
//        }
//        return ""
    }
}
