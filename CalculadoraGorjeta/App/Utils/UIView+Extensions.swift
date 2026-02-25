//
//  UIView+Extensions.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 24/02/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
