//
//  PortfolioController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

protocol PortfolioDataControllerDelegate: class {

    func controller(_ controller: PortfolioDataController, didChange coinTransactionsObject: CoinTransactionsData, at index: Int)

    func controller(_ controller: PortfolioDataController, didAdd coinTransactionsObject: CoinTransactionsData)
}

class PortfolioDataController {

    var objects: [CoinTransactionsData] = []

    weak var delegate: PortfolioDataControllerDelegate?

    func setupWithTransactions(_ transactions: [Transaction]?) {
        guard let t = transactions else {
            objects = []
            return
        }

        t.forEach {
            addTransaction($0, notifying: false)
        }
    }

    func addTransaction(_ transaction: Transaction) {
        addTransaction(transaction, notifying: true)
    }

    func removeTransaction(_ transaction: Transaction) {

    }

    private func addTransaction(_ transaction: Transaction, notifying: Bool) {
        let _targetIndex = objects.index {
            $0.coin == transaction.coin
        }

        guard let targetIndex = _targetIndex else {
            let data = CoinTransactionsData(transaction: transaction)
            objects.append(data)
            if notifying {
                delegate?.controller(self, didAdd: data)
            }
            return
        }

        let target = objects[targetIndex]
        try! target.concat(with: transaction)
        if notifying {
            delegate?.controller(self, didChange: target, at: targetIndex)
        }
    }

}

class CoinTransactionsData {

    let coin: Coin

    private(set) var amount: Float
    private(set) var avgBuyPrice: Float
    private(set) var cost: Float

    var currentCost: Float? {
        guard let price = coin.price else {
            return nil
        }

        return price * amount
    }

    var profit: Float? {
        guard let curCost = currentCost else {
            return nil
        }

        return cost - curCost
    }

    init(transaction: Transaction) {
        self.coin = transaction.coin

        let digit = transaction.type == .buy ? 1 : -1

        self.amount = Float(digit) * transaction.quantity
        self.avgBuyPrice = transaction.price.value
        self.cost = amount * avgBuyPrice
    }

    func concat(with transaction: Transaction) throws {
        guard self.coin.symbol == transaction.coin.symbol else {
            throw CoinTransactionsDataError.concatError
        }

        switch transaction.type {
        case .buy:
            let am = self.amount + transaction.quantity
            self.avgBuyPrice = self.cost / am + transaction.price.value * transaction.quantity / am
            self.amount = am
            self.cost = self.amount * self.avgBuyPrice
        case .sell:
            self.amount = self.amount - transaction.quantity
            self.cost = self.amount * avgBuyPrice
        }
    }
}

enum CoinTransactionsDataError: Error {
    case concatError
}
