//
//  Double+Extensions.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import Foundation

extension Double {

    /// 1.00234 -> 1
    var integerPart: String {
        return String(String(format: "%.2f", self).split(separator: ".")[0])
    }

    /// 1.012 --> 01
    var fractionPart: String {
        return String(String(format: "%.2f", self).split(separator: ".")[1])
    }
    
    var toString: String {
        return "\(integerPart).\(fractionPart)"
    }
}
