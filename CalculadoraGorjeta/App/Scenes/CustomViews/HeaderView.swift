//
//  HeaderView.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 24/02/26.
//

import UIKit

class HeaderView: UIView {
    
    lazy var totalAmountLabel = buildLabel(text: "VALOR TOTAL DA CONTA", textColor: .white, textAlignment: .center, font: .systemFont(ofSize: 14, weight: .semibold))
    
    lazy var amountTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .numberPad
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 24
        
        tf.attributedPlaceholder = NSAttributedString(
            string: "R$0,00",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5),
                .font: UIFont.systemFont(ofSize: 48, weight: .bold)
            ]
        )
        return tf
    }()
    
    lazy var totalPeopleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var totalPeopleLabel = buildLabel(text: "1 Pessoa", textColor: .white, font: .systemFont(ofSize: 14, weight: .bold))
    
    lazy var totalPeopleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [totalPeopleImage, totalPeopleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        return stack
    }()
    
    lazy var totalPeopleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.25)
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubviews(totalAmountLabel, amountTextField, totalPeopleContainer)
        totalPeopleContainer.addSubview(totalPeopleStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            totalAmountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            totalAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            amountTextField.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            totalPeopleContainer.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 8),
            totalPeopleContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            totalPeopleStack.topAnchor.constraint(equalTo: totalPeopleContainer.topAnchor, constant: 6),
            totalPeopleStack.bottomAnchor.constraint(equalTo: totalPeopleContainer.bottomAnchor, constant: -6),
            totalPeopleStack.leadingAnchor.constraint(equalTo: totalPeopleContainer.leadingAnchor, constant: 12),
            totalPeopleStack.trailingAnchor.constraint(equalTo: totalPeopleContainer.trailingAnchor, constant: -12),
            
            totalPeopleImage.widthAnchor.constraint(equalToConstant: 15),
            totalPeopleImage.heightAnchor.constraint(equalTo: totalPeopleImage.widthAnchor),
        ])
    }
    
    // 👇 GARANTE CÁPSULA PERFEITA
    override func layoutSubviews() {
        super.layoutSubviews()
        totalPeopleContainer.layer.cornerRadius = totalPeopleContainer.bounds.height / 2
    }
}
