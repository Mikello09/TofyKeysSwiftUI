//
//  Extensions.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 27/4/22.
//

import Foundation


extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
