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

        transactionCreatingSession.delegate = self
    }

    func setup() {
        guard let coin = transactionCreatingSession.coin, let price = coin.price else {
            return
        }

        view?.setPricePlaceholder(String(price: price))
    }

    func setTransaction(type: Transaction.TransactionType) {
        transactionCreatingSession.type = type
    }

    func setTransaction(quantity: Float?) {
        transactionCreatingSession.quantity = quantity
    }

    func setTransaction(date: Date) {
        transactionCreatingSession.date = date
    }

    func setTransaction(price: Float?) {
        transactionCreatingSession.price = price
    }

    func setTransaction(currency: Price.CurrencyType) {
        transactionCreatingSession.currency = currency
    }

    func setTransaction(market: String?) {
        transactionCreatingSession.market = market
    }

    func moveBack() {
        transactionCreatingSession.clearDetails()
        view?.moveBack()
    }
}

extension EnterTransactionDetailsPresenter: TransactionCreatingSessionDelegate {

    func creatingSession(_ creatingSession: TransactionCreatingSession, isComplete: Bool) {
        view?.showContinuationButton(isVisible: isComplete)
    }
}
