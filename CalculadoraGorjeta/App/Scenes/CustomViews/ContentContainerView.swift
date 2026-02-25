//
//  ContentContainerView.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 24/02/26.
//

import UIKit

protocol ContentContainerViewDelegate: AnyObject {
    func didTapCustom()
    func didTap10Percent()
    func didTap15Percent()
    func didTap20Percent()
    func didTap25Percent()
    func didTapMinus()
    func didTapPlus()
    func didTapShare()
}

class ContentContainerView: UIView {
    
    weak var delegate: ContentContainerViewDelegate?
    
    lazy var contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9490087628, green: 0.9491145015, blue: 0.9688453078, alpha: 1)
        return view
    }()
    
    // MARK: Tip Percentage
    lazy var tipPercentageLabel = buildLabel(text: "Porcentagem da gorjeta", font: .boldSystemFont(ofSize: 16))
    lazy var customTipButton = buildButton(title: "Personalizado", titleColor: .gray, fontSize: 12, cornerRadius: 10, target: self, selector: #selector(tappedCustom))
    lazy var tenPercentButton = buildButton(title: "10%", target: self, selector: #selector(tapped10))
    lazy var fifteenPercentButton = buildButton(title: "15%", target: self, selector: #selector(tapped15))
    lazy var twentyPercentButton = buildButton(title: "20%", target: self, selector: #selector(tapped20))
    lazy var twentyFivePercentButton = buildButton(title: "25%", target: self, selector: #selector(tapped25))
    
    lazy var buttonStack = buildStack(arrangedSubviews: [tenPercentButton, fifteenPercentButton, twentyPercentButton, twentyFivePercentButton])
    
    // MARK: Split Bill
    lazy var splitBillLabel = buildLabel(text: "Conta dividida", font: .boldSystemFont(ofSize: 16))
    
    lazy var splitBillContainer = buildContainer()
    lazy var minusButton = buildMinusPlusButton(systemNameImage: "minus", target: self, selector: #selector(tappedMinus))
    lazy var totalPeopleValue = buildLabel(text: "1", font: .boldSystemFont(ofSize: 24))
    lazy var plusButton = buildMinusPlusButton(systemNameImage: "plus", target: self, selector: #selector(tappedPlus))
    
    // MARK: Total Tip Value & Total Per Person Value
    lazy var totalTipValueContainer = buildContainer()
    lazy var totalTipLabel = buildLabel(text: "GORJETA TOTAL", textColor: .gray, font: .boldSystemFont(ofSize: 12))
    lazy var totalTipValue = buildLabel(text: "R$0,00", font: .boldSystemFont(ofSize: 24))
    
    lazy var totalPerPersonValueContainer = buildContainer()
    lazy var totalPerPersonLabel = buildLabel(text: "POR PESSOA", textColor: .gray, font: .boldSystemFont(ofSize: 12))
    lazy var totalPerPersonValue = buildLabel(text: "R$0,00", textColor: .systemGreen, font: .boldSystemFont(ofSize: 24))
    
    // MARK: Grand Total
    lazy var grandTotalContainer = buildContainer(backgroundColor: .black.withAlphaComponent(0.8))
    lazy var grandTotalLabel = buildLabel(text: "TOTAL GERAL", textColor: .gray, font: .boldSystemFont(ofSize: 12))
    lazy var grandTotalValue = buildLabel(text: "R$0,00", textColor: .white, font: .boldSystemFont(ofSize: 32))
    lazy var shareButton = buildShareButton(target: self, selector: #selector(tappedShare))
    
    // MARK: Tip Bittons
    lazy var tipButtons = [customTipButton, tenPercentButton, fifteenPercentButton, twentyPercentButton, twentyFivePercentButton]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupConfigurations()
        setButtonsEnabled(false)
    }
    
    private func setupHierarchy() {
        addSubviews(
            contentContainerView, tipPercentageLabel, customTipButton, buttonStack,
            splitBillLabel, splitBillContainer, minusButton, totalPeopleValue, plusButton,
            totalTipValueContainer, totalTipLabel, totalTipValue, totalPerPersonValueContainer, totalPerPersonLabel, totalPerPersonValue,
            grandTotalContainer, grandTotalLabel, grandTotalValue, shareButton
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tipPercentageLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 20),
            tipPercentageLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            tipPercentageLabel.trailingAnchor.constraint(equalTo: customTipButton.leadingAnchor, constant: -20),
            
            customTipButton.topAnchor.constraint(equalTo: tipPercentageLabel.topAnchor),
            customTipButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),
            
            buttonStack.topAnchor.constraint(equalTo: tipPercentageLabel.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            splitBillLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 20),
            splitBillLabel.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            
            splitBillContainer.topAnchor.constraint(equalTo: splitBillLabel.bottomAnchor, constant: 20),
            splitBillContainer.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            splitBillContainer.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            splitBillContainer.heightAnchor.constraint(equalToConstant: 70),
            
            minusButton.centerYAnchor.constraint(equalTo: splitBillContainer.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: splitBillContainer.leadingAnchor, constant: 20),
            minusButton.widthAnchor.constraint(equalToConstant: 32),
            minusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor),
            
            totalPeopleValue.centerYAnchor.constraint(equalTo: splitBillContainer.centerYAnchor),
            totalPeopleValue.centerXAnchor.constraint(equalTo: splitBillContainer.centerXAnchor),
            
            plusButton.centerYAnchor.constraint(equalTo: splitBillContainer.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: splitBillContainer.trailingAnchor, constant: -20),
            plusButton.widthAnchor.constraint(equalToConstant: 32),
            plusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            totalTipValueContainer.topAnchor.constraint(equalTo: splitBillContainer.bottomAnchor, constant: 20),
            totalTipValueContainer.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            totalTipValueContainer.heightAnchor.constraint(equalToConstant: 80),
            totalTipValueContainer.widthAnchor.constraint(equalTo: splitBillContainer.widthAnchor, multiplier: 0.5, constant: -8),
            
            totalTipLabel.topAnchor.constraint(equalTo: totalTipValueContainer.topAnchor, constant: 20),
            totalTipLabel.leadingAnchor.constraint(equalTo: totalTipValueContainer.leadingAnchor, constant: 10),
            
            totalTipValue.topAnchor.constraint(equalTo: totalTipLabel.bottomAnchor),
            totalTipValue.leadingAnchor.constraint(equalTo: totalTipLabel.leadingAnchor),
            totalTipValue.trailingAnchor.constraint(equalTo: totalTipValueContainer.trailingAnchor, constant: -10),
            
            totalPerPersonValueContainer.topAnchor.constraint(equalTo: splitBillContainer.bottomAnchor, constant: 20),
            totalPerPersonValueContainer.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            totalPerPersonValueContainer.heightAnchor.constraint(equalToConstant: 80),
            totalPerPersonValueContainer.widthAnchor.constraint(equalTo: splitBillContainer.widthAnchor, multiplier: 0.5, constant: -8),
            
            totalPerPersonLabel.topAnchor.constraint(equalTo: totalPerPersonValueContainer.topAnchor, constant: 20),
            totalPerPersonLabel.leadingAnchor.constraint(equalTo: totalPerPersonValueContainer.leadingAnchor, constant: 10),
            
            totalPerPersonValue.topAnchor.constraint(equalTo: totalPerPersonLabel.bottomAnchor),
            totalPerPersonValue.leadingAnchor.constraint(equalTo: totalPerPersonLabel.leadingAnchor),
            totalPerPersonValue.trailingAnchor.constraint(equalTo: totalPerPersonValueContainer.trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            grandTotalContainer.topAnchor.constraint(equalTo: totalPerPersonValueContainer.bottomAnchor, constant: 20),
            grandTotalContainer.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            grandTotalContainer.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            grandTotalContainer.heightAnchor.constraint(equalToConstant: 100),
            
            grandTotalLabel.topAnchor.constraint(equalTo: grandTotalContainer.topAnchor, constant: 20),
            grandTotalLabel.leadingAnchor.constraint(equalTo: grandTotalContainer.leadingAnchor, constant: 10),
            
            grandTotalValue.topAnchor.constraint(equalTo: grandTotalLabel.bottomAnchor, constant: 10),
            grandTotalValue.leadingAnchor.constraint(equalTo: grandTotalLabel.leadingAnchor),
            grandTotalValue.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -10),
            
            shareButton.centerYAnchor.constraint(equalTo: grandTotalContainer.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: grandTotalContainer.trailingAnchor, constant: -20),
            shareButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupConfigurations() {
        backgroundColor = .secondarySystemBackground
    }
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        [customTipButton, tenPercentButton, fifteenPercentButton, twentyPercentButton, twentyFivePercentButton, minusButton, plusButton, shareButton].forEach {
            $0.isEnabled = isEnabled ? true : false
            $0.alpha = isEnabled ? 1 : 0.3
            totalPeopleValue.alpha = isEnabled ? 1 : 0.3
        }
    }
    
    func selectTipButton(_ selectedButton: UIButton) {
        tipButtons.forEach { $0.isSelected = false }
        selectedButton.isSelected = true
    }
}

extension ContentContainerView {
    @objc private func tappedCustom() { delegate?.didTapCustom() }
    @objc private func tapped10() { delegate?.didTap10Percent() }
    @objc private func tapped15() { delegate?.didTap15Percent() }
    @objc private func tapped20() { delegate?.didTap20Percent() }
    @objc private func tapped25() { delegate?.didTap25Percent() }
    @objc private func tappedMinus() { delegate?.didTapMinus() }
    @objc private func tappedPlus() { delegate?.didTapPlus() }
    @objc private func tappedShare() { delegate?.didTapShare() }
}
