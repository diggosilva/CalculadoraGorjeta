//
//  CalculatorViewController.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 22/02/26.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private let contentView = CalculatorView()
    private let viewModel = CalculatorViewModel()
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegates()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Gorjeta"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupDelegates() {
        contentView.headerView.amountTextField.delegate = self
        contentView.contentContainerView.delegate = self
    }
    
    private func setupUI() {
        contentView.contentContainerView.totalTipValue.text = viewModel.totalTipText
        contentView.contentContainerView.totalPerPersonValue.text = viewModel.totalPerPersonText
        contentView.contentContainerView.grandTotalValue.text = viewModel.totalAmountText
        contentView.contentContainerView.totalPeopleValue.text = "\(viewModel.numberOfPeople)"
    }
}

extension CalculatorViewController: ContentContainerViewDelegate {
    func didTapCustom() {
        setTipButton(contentView.contentContainerView.customTipButton)
        showCustomTipAlert()
    }
    
    func didTap10Percent() {
        setTipButton(contentView.contentContainerView.tenPercentButton)
        setTipPercentage(.tenPercent)
    }
    
    func didTap15Percent() {
        setTipButton(contentView.contentContainerView.fifteenPercentButton)
        setTipPercentage(.fifteenPercent)
    }
    
    func didTap20Percent() {
        setTipButton(contentView.contentContainerView.twentyPercentButton)
        setTipPercentage(.twentyPercent)
    }
    
    func didTap25Percent() {
        setTipButton(contentView.contentContainerView.twentyFivePercentButton)
        setTipPercentage(.twentyFivePercent)
    }
    
    func didTapMinus() {
        viewModel.decreasePeopleCount()
        setupUI()
    }
    
    func didTapPlus() {
        viewModel.increasePeopleCount()
        setupUI()
    }
    
    func didTapShare() {}
    
    private func setTipPercentage(_ percentage: Tip) {
        viewModel.setTipAmount(percentage)
        setupUI()
    }
    
    private func setTipButton(_ tipButton: UIButton) {
        contentView.contentContainerView.selectTipButton(tipButton)
    }
    
    private func showCustomTipAlert() {
        let alert = UIAlertController(title: "Gorjeta customizada", message: "Seja gentil e digite o valor da gorjeta. Ex: 30,00", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Ex: 30,00"
            textField.keyboardType = .decimalPad
            
            let ok = UIAlertAction(title: "Confirmar", style: .default) { [weak self] _ in
                guard let self = self,
                    let text = textField.text, !text.isEmpty,
                      let value = Double(text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)) else {
                    return
                }
                viewModel.setTipAmount(.customTip(value))
                setupUI()
            }
            alert.addAction(ok)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        }
        present(alert, animated: true)
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let numbers = updatedText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let doubleValue = (Double(numbers) ?? 0) / 100.0
        
        textField.text = NumberFormatter.currency.string(from: NSNumber(value: doubleValue))
        
        viewModel.setBillAmount(doubleValue)
        contentView.contentContainerView.setButtonsEnabled(viewModel.isValidAmount)
        setupUI()
        return false
    }
}
