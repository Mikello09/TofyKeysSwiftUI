//
//  GlobalManager.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 2/6/22.
//

import Foundation

var USER_TOKEN: String = ""

class GlobalManager {
    
    static func generateToken() -> String {
        return UUID().uuidString
    }
    
}
