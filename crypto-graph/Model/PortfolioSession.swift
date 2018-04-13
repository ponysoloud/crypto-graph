//
//  PortfolioSession.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData

protocol PortfolioSessionDelegate: class {

    func portfolio(_ portfolio: PortfolioSession, didChange coinTransactionsObject: CoinTransactionsData, at index: Int)

    func portfolio(_ portfolio: PortfolioSession, didAdd coinTransactionsObject: CoinTransactionsData)

    func portfolio(_ portfolio: PortfolioSession, didRemove coinTransactionsObject: CoinTransactionsData, from index: Int)

}

class PortfolioSession: NSObject {

    weak var delegate: PortfolioSessionDelegate?

    private let fetchedTransactionsController: NSFetchedResultsController<Transaction>
    private let portfolioController: PortfolioDataController
    private let coinsAPI: CoinsAPI

    var portfolioItems: [CoinTransactionsData] {
        return portfolioController.objects
    }

    var totalData: TotalTransactionsData {
        var sumCost: Float = 0
        var currentCost: Float = 0

        portfolioItems.forEach {
            sumCost += $0.cost
            currentCost += $0.currentCost ?? 0
        }

        return TotalTransactionsData(currentValue: currentCost == 0 ? nil : currentCost, totalCost: sumCost)
    }

    init(coinsAPI: CoinsAPI, fetchedTransactionsController: NSFetchedResultsController<Transaction>, portfolioController: PortfolioDataController) {
        self.coinsAPI = coinsAPI
        self.fetchedTransactionsController = fetchedTransactionsController
        self.portfolioController = portfolioController
    }

    func setup() {
        fetchedTransactionsController.delegate = self
        portfolioController.delegate = self

        do {
            try fetchedTransactionsController.performFetch()

            let transactions = fetchedTransactionsController.fetchedObjects
            portfolioController.setupWithTransactions(transactions)
        } catch {
            print(error)
        }
    }

    func refreshPrices() {
        portfolioItems.forEach { obj in
            requestForCoinTransactionsDataPrice(obj)
        }
    }

    func refreshPriceForItem(at index: Int) {
        guard index < portfolioItems.count else {
            fatalError()
        }

        let item = portfolioItems[index]
        requestForCoinTransactionsDataPrice(item)
    }

    private func requestForCoinTransactionsDataPrice(_ coinTransactionsData: CoinTransactionsData) {
        let index = portfolioItems.index {
            $0.coin.symbol == coinTransactionsData.coin.symbol
        }!

        coinsAPI.fetchCoinPrice(coinTransactionsData.coin, success: { coin in
            self.delegate?.portfolio(self, didChange: coinTransactionsData, at: index)
        }, failure: {
            print($0)
        })
    }

}

extension PortfolioSession: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let object = anObject as? Transaction else {
            fatalError()
        }

        switch type {
        case .insert:
            portfolioController.addTransaction(object)
        case .delete:
            portfolioController.removeTransaction(object)
        default:
            return
        }
    }
}

extension PortfolioSession: PortfolioDataControllerDelegate {
    
    func controller(_ controller: PortfolioDataController, didChange coinTransactionsObject: CoinTransactionsData, at index: Int) {
        requestForCoinTransactionsDataPrice(coinTransactionsObject)
        delegate?.portfolio(self, didChange: coinTransactionsObject, at: index)
    }

    func controller(_ controller: PortfolioDataController, didAdd coinTransactionsObject: CoinTransactionsData) {
        delegate?.portfolio(self, didAdd: coinTransactionsObject)
        requestForCoinTransactionsDataPrice(coinTransactionsObject)
    }

    func controller(_ controller: PortfolioDataController, didRemove coinTransactionsObject: CoinTransactionsData, from index: Int) {
        delegate?.portfolio(self, didRemove: coinTransactionsObject, from: index)
    }
}

struct TotalTransactionsData {

    let currentValue: Float?
    let totalCost: Float

    var totalProfit: Float? {
        guard let current = currentValue else {
            return nil
        }

        return ((current - totalCost)*100.0)/totalCost
    }

}
