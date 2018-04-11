//
//  MyPortfolioPresenter.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class PortfolioPresenter {

    private weak var view: PortfolioView?

    private let portfolioSession: PortfolioSession
    private var portfolioTotalViewData: TotalTransactionsViewData!
    private var portfolioViewData: [CoinTransactionsViewData] = []

    init(view: PortfolioView, portfolioSession: PortfolioSession) {
        self.view = view
        self.portfolioSession = portfolioSession
    }

    func setup() {
        portfolioSession.delegate = self
        portfolioSession.setup()
        portfolioSession.refreshPrices()

        portfolioTotalViewData = buildViewData(from: portfolioSession.totalData)
        portfolioViewData = portfolioSession.portfolioItems.map {
            buildViewData(from: $0)
        }

        view?.updateHeader(with: portfolioTotalViewData)
        view?.provide(data: portfolioViewData)
    }

    func refreshPortfolio() {
        portfolioSession.refreshPrices()
    }

    func refreshItem(at index: Int) {
        portfolioSession.refreshPriceForItem(at: index)
    }

    private func updateHeader() {
        portfolioTotalViewData = buildViewData(from: portfolioSession.totalData)
        view?.updateHeader(with: portfolioTotalViewData)
    }

    private func buildViewData(from data: TotalTransactionsData) -> TotalTransactionsViewData {
        let viewData = TotalTransactionsViewData(currentCost: data.currentValue, cost: data.totalCost, profit: data.totalProfit)

        return viewData
    }

    private func buildViewData(from data: CoinTransactionsData) -> CoinTransactionsViewData {
        let viewData = CoinTransactionsViewData(coinImage: data.coin.image, coinName: data.coin.fullname, currentPrice: data.coin.price, change1h: data.coin.percentChange1h, currentCost: data.currentCost, amount: data.amount, avgBuyPrice: data.avgBuyPrice, cost: data.cost, profit: data.profit)

        return viewData
    }
}

extension PortfolioPresenter: PortfolioSessionDelegate {

    func portfolio(_ portfolio: PortfolioSession, didChange coinTransactionsObject: CoinTransactionsData, at index: Int) {
        DispatchQueue.main.async {
            let viewData = self.buildViewData(from: coinTransactionsObject)
            self.view?.updateObject(existingAt: index, with: viewData)

            self.updateHeader()
        }

        print("CHANGE: - coin: \(coinTransactionsObject.coin.name) coinPrice: \(coinTransactionsObject.coin.price ?? 0)  amount: \(coinTransactionsObject.amount) price: \(coinTransactionsObject.avgBuyPrice) cost: \(coinTransactionsObject.cost)")
    }

    func portfolio(_ portfolio: PortfolioSession, didAdd coinTransactionsObject: CoinTransactionsData) {
        DispatchQueue.main.async {
            let viewData = self.buildViewData(from: coinTransactionsObject)
            self.view?.append(viewData)
        }

        print("ADD: - coin: \(coinTransactionsObject.coin.name) coinPrice: \(coinTransactionsObject.coin.price ?? 0)  amount: \(coinTransactionsObject.amount) price: \(coinTransactionsObject.avgBuyPrice) cost: \(coinTransactionsObject.cost)")
    }

    func portfolio(_ portfolio: PortfolioSession, didRemove coinTransactionsObject: CoinTransactionsData, from index: Int) {
        DispatchQueue.main.async {
            self.view?.remove(at: index)
        }

        print("REMOVE: - coin: \(coinTransactionsObject.coin.name)")
    }
}

struct CoinTransactionsViewData {

    let coinImage: UIImage?

    let coinName: String
    let currentPrice: Float?
    let change1h: Float?
    let currentCost: Float?

    let amount: Float
    let avgBuyPrice: Float
    let cost: Float

    let profit: Float?
}

struct TotalTransactionsViewData {

    let currentCost: Float?
    let cost: Float
    let profit: Float?
}
