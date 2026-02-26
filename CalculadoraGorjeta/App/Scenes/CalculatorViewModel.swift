//
//  CalculatorViewModel.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 24/02/26.
//

import Foundation

enum Tip {
    case zeroPercent
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case twentyFivePercent
    case customTip(Double)
}

final class CalculatorViewModel {
    
    // inputs
    var billAmount: Double = 0
    var tipPercentage: Tip = .zeroPercent
    var numberOfPeople: Int = 1
    var isValidAmount: Bool = false
    
    // outputs
    var totalAmountText: String = "R$0,00"
    var totalTipText: String = "R$0,00"
    var totalPerPersonText: String = "R$0,00"
    
    func setBillAmount(_ amount: Double) {
        billAmount = amount
        
        if billAmount > 0 {
            isValidAmount = true
            recalculate()
        } else {
            isValidAmount = false
            clear()
        }
    }
    
    func setTipAmount(_ tip: Tip) {
        tipPercentage = tip
        recalculate()
    }
    
    func decreasePeopleCount() {
        numberOfPeople = max(1, numberOfPeople - 1)
        recalculate()
    }
    
    func increasePeopleCount() {
        numberOfPeople += 1
        recalculate()
    }
    
    func clear() {
        billAmount = 0
        tipPercentage = .zeroPercent
        numberOfPeople = 1
        isValidAmount = false
        
        totalAmountText = "R$0,00"
        totalTipText = "R$0,00"
        totalPerPersonText = "R$0,00"
    }
    
    private func recalculate() {
        var totalAmount: Double
        var totalTip: Double
        var totalPerPerson: Double
        
        switch tipPercentage {
        case .zeroPercent: totalTip = 0
        case .tenPercent: totalTip = billAmount * 0.10
        case .fifteenPercent: totalTip = billAmount * 0.15
        case .twentyPercent: totalTip = billAmount * 0.20
        case .twentyFivePercent: totalTip = billAmount * 0.25
        case .customTip(let value): totalTip = value
        }
        
        totalAmount = billAmount + totalTip
        totalPerPerson = totalAmount / (Double(numberOfPeople))
        
        totalAmountText = formatCurrency(totalAmount)
        totalTipText = formatCurrency(totalTip)
        totalPerPersonText = formatCurrency(totalPerPerson)
    }
}

func formatCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.usesGroupingSeparator = true
    return formatter.string(from: NSNumber(value: value)) ?? "RS0,00"
}
