//
//  NumberFormatter+Extensions.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 25/02/26.
//

import Foundation

extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}
