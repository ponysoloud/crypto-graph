//
//  AddTransactionPresenter.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class ChooseCoinPresenter: ChooseCoinViewPresenter {

    private weak var view: ChooseCoinView?
    private let coinsAPI: CoinsAPI
    private let transactionCreatingSession: TransactionCreatingSession

    // MARK: - Public init and methods to use from view side.

    required init(view: ChooseCoinView, transactionCreatingSession: TransactionCreatingSession, coinsAPI: CoinsAPI) {
        self.view = view
        self.coinsAPI = coinsAPI

        self.transactionCreatingSession = transactionCreatingSession
    }

    func updateSearchingQuery(with text: String) {
        filterString = text
    }

    func chooseSearchingResult(_ coin: CoinViewData) {
        guard let c = appropriateCoins.first(where: { $0.symbol == coin.symbol } ) else {
            fatalError("Presenter's result array doesn't comform view array")
        }

        coinsAPI.fetchCoinPrice(c, success: { coin in
            print("Fetched coin")
        }, failure: {
            print($0)
        })

        transactionCreatingSession.coin = c
    }


    // MARK: - Private presenter's properties and functions.

    private var appropriateCoins: [Coin] = []

    private var filterString: String = "" {
        didSet {
            // Return if the filter string hasn't changed.
            guard filterString != oldValue else { return }
            guard filterString != "" else { view?.provide(items: []); return }

            view?.showLoading(isVisible: true)
            request(forQuery: filterString) {
                [weak self] in

                self?.view?.showLoading(isVisible: false)
            }
        }
    }

    private func request(forQuery query: String, completion: (() -> Void)? = nil) {
        coinsAPI.cancelAllTasks()

        coinsAPI.fetchAllCoins(query: query, limits: 10, success: {
            [weak self]
            coins in

            guard let strongSelf = self else {
                completion?()
                return
            }

            strongSelf.appropriateCoins = coins

            let coinsViewData = strongSelf.buildViewData(from: coins)
            strongSelf.view?.provide(items: coinsViewData)

            completion?()
        }, failure: {
            _ in
            completion?()
        })
    }

    private func buildViewData(from coins: [Coin]) -> [CoinViewData] {
        return coins.map { coin in
            CoinViewData(name: coin.fullname, symbol: coin.symbol, image: coin.image)
        }
    }

}

struct CoinViewData {

    let name: String
    let symbol: String
    let image: UIImage?

}
