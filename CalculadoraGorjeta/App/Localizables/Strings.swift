//
//  Strings.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 02/03/26.
//

import Foundation

enum L10n {
    enum HeaderView {
        static let totalAmount = NSLocalizedString("total_amount_label", comment: "")
        static let totalPeople = NSLocalizedString("total_people_label", comment: "")
    }
    
    enum ContentContainerView {
        static let tipPercentage = NSLocalizedString("tip_percentage_label", comment: "")
        static let customTip = NSLocalizedString("custom_tip_button", comment: "")
        static let splitBill = NSLocalizedString("split_bill_label", comment: "")
        static let totalTip = NSLocalizedString("total_tip_label", comment: "")
        static let totalPerPerson = NSLocalizedString("total_per_person_label", comment: "")
        static let grandTotal = NSLocalizedString("grand_total_label", comment: "")
    }
    
    enum Calculator {
        static let title = NSLocalizedString("title", comment: "")
    }
    
    enum Alert {
        static let title = NSLocalizedString("title_alert", comment: "")
        static let message = NSLocalizedString("message_alert", comment: "")
        static let placeholder = NSLocalizedString("placeholder_alert", comment: "")
        static let ok = NSLocalizedString("ok_button", comment: "")
        static let cancel = NSLocalizedString("cancel_button", comment: "")
    }
}
