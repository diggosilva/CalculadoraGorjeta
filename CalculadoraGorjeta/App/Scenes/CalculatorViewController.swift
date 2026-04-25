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
        let clearButton = UIBarButtonItem(image: UIImage(systemName: "eraser.fill"), style: .plain, target: self, action: #selector(didTapClearUI))
        clearButton.accessibilityIdentifier = "clearButton"
        navigationItem.rightBarButtonItem = clearButton
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
    
    @objc private func didTapClearUI() {
        viewModel.clear()
        contentView.resetData()
        setupUI()
        view.endEditing(true)
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
        alert.view.accessibilityIdentifier = "customTipAlert"
        
        alert.addTextField { textField in
            textField.placeholder = L10n.Alert.placeholder
            textField.keyboardType = .decimalPad
            textField.accessibilityIdentifier = "customTipTextField"
        }
        
        let ok = UIAlertAction(title: L10n.Alert.ok, style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let text = alert?.textFields?.first?.text,
                  !text.isEmpty else { return }
            
            let formatter = NumberFormatter()
            formatter.locale = .current
            formatter.numberStyle = .decimal
            
            if let number = formatter.number(from: text) {
                let value = number.doubleValue
                viewModel.setTipAmount(.customTip(value))
                setupUI()
            }
        }
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: L10n.Alert.cancel, style: .cancel))
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
