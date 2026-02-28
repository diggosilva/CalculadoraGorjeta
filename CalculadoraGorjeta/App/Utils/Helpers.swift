//
//  Helpers.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 24/02/26.
//

import UIKit

func buildLabel(text: String, textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, font: UIFont? = nil) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.textColor = textColor
    label.textAlignment = textAlignment
    label.font = font
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
}

func buildButton(title: String = "", titleColor: UIColor = .black, fontSize: CGFloat = 16, cornerRadius: CGFloat = 15, target: Any?, selector: Selector) -> UIButton {
    var configuration = UIButton.Configuration.filled()
    configuration.titlePadding = 10
    configuration.baseBackgroundColor = .white
    configuration.background.cornerRadius = cornerRadius
    
    var attributedTitle = AttributedString(title)
    attributedTitle.font = .boldSystemFont(ofSize: fontSize)
    configuration.attributedTitle = attributedTitle
    
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.systemGray5.cgColor
    
    button.configurationUpdateHandler = { button in
        if button.isSelected {
            button.configuration?.baseBackgroundColor = .mainAppColor
            button.configuration?.baseForegroundColor = .white
        } else {
            button.configuration?.baseBackgroundColor = .white
            button.configuration?.baseForegroundColor = .black
        }
    }
    
    button.addTarget(target, action: selector, for: .touchUpInside)
    return button
}

func buildStack(arrangedSubviews: [UIView]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    return stackView
}

func buildMinusPlusButton(systemNameImage: String, target: Any?, selector: Selector) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: systemNameImage), for: .normal)
    button.tintColor = .white
    button.backgroundColor = .mainAppColor
    button.addTarget(target, action: selector, for: .touchUpInside)
    button.layer.cornerRadius = 16
    return button
}

func buildContainer(backgroundColor: UIColor = .white) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = backgroundColor
    view.layer.cornerRadius = 15
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 5, height: 5)
    view.layer.shadowOpacity = 0.1
    view.layer.shadowRadius = 5
    return view
}

func buildShareButton(target: Any?, selector: Selector) -> UIButton {
    var configuration = UIButton.Configuration.filled()
    configuration.titlePadding = 10
    configuration.background.cornerRadius = 10
    
    // Tamanho da imagem com SymbolConfiguration
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
    configuration.image = UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: imageConfig)
    
    configuration.baseBackgroundColor = .mainAppColor
    configuration.baseForegroundColor = .white
    configuration.title = "Compartilhar"
    configuration.imagePlacement = .trailing
    configuration.imagePadding = 5
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(target, action: selector, for: .touchUpInside)
    return button
}
