//
//  EnterTransactionDetailsViewPresenter.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 04.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

protocol EnterTransactionDetailsViewPresenter: class {

    init(view: EnterTransactionDetailsView, transactionCreatingSession: TransactionCreatingSession)

    func setTransaction(type: Transaction.TransactionType)

    func setTransaction(quantity: Float)

    func setTransaction(date: Date)

    func setTransaction(price: Float)

    func setTransaction(currency: Price.CurrencyType)

}
