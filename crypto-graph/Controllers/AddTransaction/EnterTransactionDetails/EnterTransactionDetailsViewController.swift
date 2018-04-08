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

    @IBOutlet fileprivate var transactionTypeTextField: UITextField!
    @IBOutlet fileprivate var quantityTextField: UITextField!
    @IBOutlet fileprivate var priceTextField: UITextField!
    @IBOutlet fileprivate var currencyTextField: UITextField!

    @IBOutlet fileprivate var dateTextField: UITextField!
    @IBOutlet fileprivate var datePicker: UIDatePicker!

    private var leaveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        transactionTypeTextField.addTarget(self, action: #selector(showTransactionTypeChoices(_:)), for: .touchDown)
        currencyTextField.addTarget(self, action: #selector(showCurrencyChoices(_:)), for: .touchDown)
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)

        datePicker.datePickerMode = .date

        quantityTextField.keyboardType = .decimalPad
        priceTextField.keyboardType = .decimalPad

        quantityTextField.delegate = self
        priceTextField.delegate = self

        quantityTextField.tag = 1
        priceTextField.tag = 2

        leaveButton = UIBarButtonItem(image: #imageLiteral(resourceName: "exit_icon"), style: .plain, target: self, action: #selector(tapLeaveSession(_:)))
        leaveButton.tintColor = UIColor.black.withAlphaComponent(0.1)

        navigationItem.rightBarButtonItem = leaveButton
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
    func showCurrencyChoices(_ sender: UITextField) {
        let choices = [Price.CurrencyType.btc.string, Price.CurrencyType.rub.string, Price.CurrencyType.eur.string, Price.CurrencyType.usd.string]
        let picker = ChoiceBottomPicker(title: "Currency", choices: choices, chooseAction: { choice in
            sender.text = choice

            guard let value = Price.CurrencyType(string: choice) else {
                fatalError()
            }
            self.presenter?.setTransaction(currency: value)
        })

        picker.present(in: self)
    }

    @objc
    func tapLeaveSession(_ sender: Any) {
        transactionDelegate?.leave()
    }
}

extension EnterTransactionDetailsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {
            return false
        }

        let new = (text as NSString).replacingCharacters(in: range, with: string)

        switch textField.tag {
        case 1:
            guard let value = Float(new) else {
                return false
            }
            presenter?.setTransaction(quantity: value)
            return true
        case 2:
            guard let value = Float(new) else {
                return false
            }
            presenter?.setTransaction(price: value)
            return true
        default:
            return true
        }
    }
}

extension EnterTransactionDetailsViewController: EnterTransactionDetailsView {

    func showContinuationButton(isVisible: Bool) {
        if isVisible {
            if let _ = view.viewWithTag(11) {
                return
            }

            let button = LargeButton(frame: CGRect.zero)
            button.setTitle("Add transaction")

            button.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(button)
            button.tag = 11
            button.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0).isActive = true

            button.addTarget(self, action: #selector(continuationButtonTap(_:)), for: .touchUpInside)

            button.animateAppearing()
        } else {
            guard let button = view.viewWithTag(11) as? LargeButton else {
                return
            }

            button.animateDisapperating() {
                button.removeFromSuperview()
            }
        }
    }

    @objc
    func continuationButtonTap(_ sender: Any) {
        transactionDelegate?.completeEnteringDetailsStep()
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
