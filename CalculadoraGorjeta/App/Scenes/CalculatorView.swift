//
//  CalculatorView.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 24/02/26.
//

import UIKit

final class CalculatorView: UIView {
    
    lazy var headerView = HeaderView()
    lazy var contentContainerView = ContentContainerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupConfigurations()
    }
    
    private func setupHierarchy() {
        addSubviews(headerView, contentContainerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
            
            contentContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupConfigurations() {
        [headerView, contentContainerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        contentContainerView.layer.cornerRadius = 32
        contentContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentContainerView.layer.masksToBounds = true
        backgroundColor = .mainAppColor
    }
}
