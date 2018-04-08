//
//  AddTransactionView.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 04.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

protocol AddTransactionView: class {

    func showChooseCoinScreen(with creatingSession: TransactionCreatingSession, coinsAPI: CoinsAPI)

    func showEnterDetailsScreen(with creatingSession: TransactionCreatingSession)

    func complete()

}
