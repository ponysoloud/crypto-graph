//
//  EnterTransactionDetailsViewController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class EnterTransactionDetailsViewController: UIViewController {

    var presenter: EnterTransactionDetailsViewPresenter?

    var transactionDelegate: AddTransactionNavigationControllerDelegate?

    @IBOutlet private var transactionTypeTextField: UITextField!
    @IBOutlet private var marketTextField: UITextField!
    @IBOutlet private var quantityTextField: UITextField!
    @IBOutlet private var priceTextField: UITextField!

    @IBOutlet private var dateTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!

    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var leaveButton: UIButton!
    @IBOutlet private var completeButton: UIButton!
    @IBOutlet private var completeButtonTrailingConstraint: NSLayoutConstraint!

    private let completeButtonTrailingDefaultConstant: CGFloat = -81.0

    override func viewDidLoad() {
        super.viewDidLoad()

        addHidingKeyboardOnTap()

        presenter?.setup()

        transactionTypeTextField.addTarget(self, action: #selector(showTransactionTypeChoices(_:)), for: .touchDown)
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        priceTextField.addTarget(self, action: #selector(priceTextFieldEditingChanged(_:)), for: .editingChanged)

        dateTextField.placeholder = DateFormatter.custom.string(from: Date())
        datePicker.datePickerMode = .date

        quantityTextField.keyboardType = .decimalPad
        priceTextField.keyboardType = .decimalPad

        quantityTextField.delegate = self
        priceTextField.delegate = self
        marketTextField.delegate = self

        quantityTextField.tag = 1
        priceTextField.tag = 2
        marketTextField.tag = 3

        backButton.addTarget(self, action: #selector(moveBack(_:)), for: .touchUpInside)
        leaveButton.addTarget(self, action: #selector(leaveSession(_:)), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeSession(_:)), for: .touchUpInside)
        completeButton.isUserInteractionEnabled = false
    }

    @objc
    func datePickerChanged(_ sender: UIDatePicker) {
        let dateString = DateFormatter.custom.string(from: datePicker.date)
        dateTextField.text = dateString

        presenter?.setTransaction(date: datePicker.date)
    }

    @objc
    func showTransactionTypeChoices(_ sender: UITextField) {
        let choices = [Transaction.TransactionType.buy.string, Transaction.TransactionType.sell.string]
        let picker = ChoiceBottomPicker(title: "Type", choices: choices, chooseAction: { choice in
            sender.text = choice

            guard let value = Transaction.TransactionType(string: choice) else {
                fatalError()
            }
            self.presenter?.setTransaction(type: value)
        })

        picker.present(in: self)
    }

    @objc
    func priceTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }

        if let first = text.first, first != "$" {
            sender.text!.insert("$", at: text.startIndex)
        }
    }

    @objc
    private func moveBack(_ sender: Any) {
        presenter?.moveBack()
    }

    @objc
    private func leaveSession(_ sender: Any) {
        transactionDelegate?.leave()
    }

    @objc
    private func completeSession(_ sender: Any) {
        transactionDelegate?.completeEnteringDetailsStep()
    }
}

extension EnterTransactionDetailsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {
            return false
        }

        var new = (text as NSString).replacingCharacters(in: range, with: string)

        switch textField.tag {
        case 1:
            guard let value = Float(new) else {
                if new == "" {
                    presenter?.setTransaction(quantity: nil)
                    return true
                }
                
                return false
            }
            presenter?.setTransaction(quantity: value)
            return true
        case 2:
            if new.hasPrefix("$") {
                let index = new.index(after: new.startIndex)
                new = String(new.suffix(from: index))
            }

            guard let value = Float(new) else {
                if new == "" {
                    presenter?.setTransaction(price: nil)
                    return true
                }

                return false
            }
            
            presenter?.setTransaction(price: value)
            return true
        case 3:
            presenter?.setTransaction(market: new == "" ? nil : new)
            return true
        default:
            return true
        }
    }
}

extension EnterTransactionDetailsViewController: EnterTransactionDetailsView {

    func moveBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func setPricePlaceholder(_ placeholder: String) {
        priceTextField.placeholder = placeholder
    }

    func showContinuationButton(isVisible: Bool) {
        if isVisible {
            guard !completeButton.isUserInteractionEnabled else {
                return
            }

            completeButton.isHidden = false
            completeButton.isUserInteractionEnabled = false

            completeButtonTrailingConstraint.constant = completeButtonTrailingDefaultConstant
            UIView.animate(withDuration: 0.3, animations: {
                self.completeButtonTrailingConstraint.constant = 14
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.completeButton.isUserInteractionEnabled = true
            })
        } else {
            guard completeButton.isUserInteractionEnabled else {
                return
            }

            completeButton.isUserInteractionEnabled = false
            completeButtonTrailingConstraint.constant = 14
            UIView.animate(withDuration: 0.3, animations: {
                self.completeButtonTrailingConstraint.constant = self.completeButtonTrailingDefaultConstant
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension Transaction.TransactionType {
    var string: String {
        switch self {
        case .buy:
            return "Buy"
        case .sell:
            return "Sell"
        }
    }

    init?(string: String) {
        if string == "Buy" {
            self = .buy
        } else if string == "Sell" {
            self = .sell
        } else {
            return nil
        }
    }
}

extension Price.CurrencyType {
    var string: String {
        switch self {
        case .btc:
            return "BTC"
        case .rub:
            return "RUB"
        case .eur:
            return "EUR"
        case .usd:
            return "USD"
        }
    }

    init?(string: String) {
        if string == "BTC" {
            self = .btc
        } else if string == "RUB" {
            self = .rub
        } else if string == "EUR" {
            self = .eur
        } else if string == "USD" {
            self = .usd
        } else {
            return nil
        }
    }
}
