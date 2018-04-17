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

    func controller(_ controller: PortfolioDataController, didRemove coinTransactionsObject: CoinTransactionsData, from index: Int)
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
        let _targetIndex = objects.index {
            $0.coin == transaction.coin
        }

        guard let targetIndex = _targetIndex else {
            return
        }

        let target = objects[targetIndex]
        do {
            try target.subtract(transaction: transaction)
        } catch {
        }

        if target.isEmpty {
            delegate?.controller(self, didRemove: target, from: targetIndex)
            objects.remove(at: targetIndex)
        } else {
            delegate?.controller(self, didChange: target, at: targetIndex)
        }
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

    var markets: String {
        var markets: [String] = []

        history.forEach { hist in
            if !markets.contains(where: { market in
                market.lowercased() == hist.market.lowercased()
            }) {
                markets.append(hist.market)
            }
        }

        return markets.joined(separator: ", ")
    }

    var amount: Float {
        return history.reduce(0, {
            switch $1.type {
            case .buy:
                return $0 + $1.quantity
            case .sell:
                return $0 - $1.quantity
            }
        })
    }

    var avgBuyPrice: Float {
        var buyQuantity = history.filter({
            $0.type == .buy
        }).reduce(0, {
            $0 + $1.quantity
        })

        let buyValue = history.filter({
            $0.type == .buy
        }).reduce(0, {
            $0 + $1.value
        })

        if buyQuantity == 0 {
            buyQuantity = 1
        }

        return buyValue/buyQuantity
    }

    var cost: Float {
        return history.reduce(0, {
            switch $1.type {
            case .buy:
                return $0 + $1.value
            case .sell:
                return $0 - $1.value
            }
        })
    }

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

        if cost == 0 {
            return 0
        }

        return ((curCost - cost) * 100.0)/cost
    }

    var isEmpty: Bool {
        return amount == 0 && avgBuyPrice == 0 && cost == 0
    }

    struct History {
        let id: String

        let type: Transaction.TransactionType
        let price: Float
        let quantity: Float

        let market: String

        var value: Float {
            return price * quantity
        }
    }

    private var history: [History] = []

    init(transaction: Transaction) {
        self.coin = transaction.coin

        let id = transaction.objectID.uriRepresentation().absoluteString

        history.append(History(id: id, type: transaction.type, price: transaction.price.value, quantity: transaction.quantity, market: transaction.market))
    }

    func concat(with transaction: Transaction) throws {
        guard self.coin.symbol == transaction.coin.symbol else {
            throw ConcatError.transactionCoinDoesntCorresponds
        }

        let id = transaction.objectID.uriRepresentation().absoluteString

        guard !history.contains(where: { $0.id == id }) else {
            throw ConcatError.transactionAlreadyConcatenated
        }

        history.append(History(id: id, type: transaction.type, price: transaction.price.value, quantity: transaction.quantity, market: transaction.market))
    }

    func subtract(transaction: Transaction) throws {
        guard self.coin.symbol == transaction.coin.symbol else {
            throw SusbtractError.transactionCoinDoesntCorresponds
        }

        let id = transaction.objectID.uriRepresentation().absoluteString

        guard let index = history.index(where: { $0.id == id }) else {
            throw SusbtractError.transactionWasntConcatenatedBefore
        }

        history.remove(at: index)
    }

    enum ConcatError: Error {
        case concatError
        case transactionCoinDoesntCorresponds
        case transactionAlreadyConcatenated
    }

    enum SusbtractError: Error {
        case transactionCoinDoesntCorresponds
        case transactionWasntConcatenatedBefore
    }
}


