//
//  AddTransactionPresenter.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

class AddTransactionPresenter {

    private weak var view: AddTransactionView?
    private let transactionCreatingSession: TransactionCreatingSession
    private let coinsAPI: CoinsAPI

    init(view: AddTransactionView, transactionCreatingSession: TransactionCreatingSession, coinsAPI: CoinsAPI) {
        self.view = view
        self.transactionCreatingSession = transactionCreatingSession
        self.coinsAPI = coinsAPI
    }

    func showRootScreen() {
        view?.showChooseCoinScreen(with: transactionCreatingSession, coinsAPI: coinsAPI)
    }

    func completeChoosingCoin() {
        guard let _ = transactionCreatingSession.coin else {
            fatalError("Choosing coin complete, but coin property in creating session is nil")
        }

        view?.showEnterDetailsScreen(with: transactionCreatingSession)
    }

    func completeEnteringDetails() {
        let session = transactionCreatingSession

        guard
            let _ = session.price,
            let _ = session.quantity,
            let _ = session.date,
            let _ = session.type
            else {
                fatalError("Entering details complete, but details properties in creating session are nil")
        }

        transactionCreatingSession.getTransaction { transaction in
            guard let _ = transaction else {
                fatalError()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.view?.complete()
            }
        }
    }

}
