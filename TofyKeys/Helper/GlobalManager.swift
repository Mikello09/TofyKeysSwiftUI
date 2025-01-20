//
//  GlobalManager.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 2/6/22.
//

import Foundation

class GlobalManager {
    static var shared: GlobalManager = GlobalManager()
}

// USER
var USER_TOKEN: String = ""
extension GlobalManager {
    func generateToken() -> String {
        return UUID().uuidString
    }
}

