//
//  CalculatorViewController.swift
//  CalculadoraGorjeta
//
//  Created by Diggo Silva on 22/02/26.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private let contentView = CalculatorView()
    private let viewModel: CalculatorViewModel
    
    init(viewModel: CalculatorViewModel = CalculatorViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegates()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = L10n.Calculator.title
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
    
    func didTapShare() {
        shareFile()
    }
    
    private func setTipPercentage(_ percentage: Tip) {
        viewModel.setTipAmount(percentage)
        setupUI()
    }
    
    private func setTipButton(_ tipButton: UIButton) {
        contentView.contentContainerView.selectTipButton(tipButton)
    }
    
    private func showCustomTipAlert() {
        let alert = UIAlertController(title: L10n.Alert.title, message: L10n.Alert.message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = L10n.Alert.placeholder
            textField.keyboardType = .decimalPad
            
            let ok = UIAlertAction(title: L10n.Alert.ok, style: .default) { [weak self] _ in
                guard let self = self,
                      let text = textField.text, !text.isEmpty,
                      let value = Double(text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)) else {
                    return
                }
                viewModel.setTipAmount(.customTip(value))
                setupUI()
            }
            alert.addAction(ok)
            alert.addAction(UIAlertAction(title: L10n.Alert.cancel, style: .cancel, handler: nil))
        }
        present(alert, animated: true)
    }
    
    private func shareFile() {
        let text = viewModel.exportData()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmm"
        formatter.locale = Locale.current
        
        let formatedDate = "\(formatter.string(from: Date()))"
        
        let fileName = "\(L10n.Share.fileName)-\(formatedDate).txt"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try text.write(to: tempURL, atomically: true, encoding: .utf8)
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = view
            present(activityVC, animated: true)
        } catch {
            print("\(L10n.Share.errorMessage): \(error)")
        }
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
