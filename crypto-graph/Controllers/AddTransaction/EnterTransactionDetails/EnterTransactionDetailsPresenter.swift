//
//  EnterTransactionDetailsPresenter.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

class EnterTransactionDetailsPresenter: EnterTransactionDetailsViewPresenter {

    private weak var view: EnterTransactionDetailsView?
    private let transactionCreatingSession: TransactionCreatingSession

    // MARK: - Public init and methods to use from view side.

    required init(view: EnterTransactionDetailsView, transactionCreatingSession: TransactionCreatingSession) {
        self.view = view
        self.transactionCreatingSession = transactionCreatingSession
    }

    func setTransaction(type: Transaction.TransactionType) {
        transactionCreatingSession.type = type
        checkCompletion()
    }

    func setTransaction(quantity: Float) {
        transactionCreatingSession.quantity = quantity
        checkCompletion()
    }

    func setTransaction(date: Date) {
        transactionCreatingSession.date = date
        checkCompletion()
    }

    func setTransaction(price: Float) {
        transactionCreatingSession.price = price
        checkCompletion()
    }

    func setTransaction(currency: Price.CurrencyType) {
        transactionCreatingSession.currency = currency
        checkCompletion()
    }

    // MARK: - Private presenter's properties and functions.

    private func checkCompletion() {
        if transactionCreatingSession.isComplete {
            view?.showContinuationButton(isVisible: true)
        } else {
            view?.showContinuationButton(isVisible: false)
        }
    }
}
