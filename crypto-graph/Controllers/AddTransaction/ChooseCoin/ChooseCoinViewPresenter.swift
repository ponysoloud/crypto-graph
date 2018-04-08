//
//  ChooseCoinPresenterProtocol.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 04.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

protocol ChooseCoinViewPresenter: class {

    init(view: ChooseCoinView, transactionCreatingSession: TransactionCreatingSession, coinsAPI: CoinsAPI)

    func updateSearchingQuery(with text: String)

    func chooseSearchingResult(_ coin: CoinViewData)
}

