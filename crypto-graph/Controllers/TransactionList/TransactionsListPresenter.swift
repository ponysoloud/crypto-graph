//
//  TransactionsListPresenter.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TransactionsListPresenter: NSObject {

    private weak var view: TransactionsListView?

    private let fetchedTransactionsController: NSFetchedResultsController<Transaction>
    private let context: NSManagedObjectContext

    private var transactionsViewData: [TransactionViewData] = []
    private var chartData: [CoinChartData] = []


    init(view: TransactionsListView, fetchedTransactionsController: NSFetchedResultsController<Transaction>, context: NSManagedObjectContext) {
        self.view = view
        self.fetchedTransactionsController = fetchedTransactionsController
        self.context = context
    }

    func setup() {
        fetchedTransactionsController.delegate = self

        do {
            try fetchedTransactionsController.performFetch()

            refresh()
        } catch {
            print(error)
        }
    }

    func refresh() {
        guard let transactions = fetchedTransactionsController.fetchedObjects else {
            return
        }
        
        transactionsViewData = transactions.map {
            self.buildViewData(from: $0)
        }
        chartData = evaluateGraphData(from: transactions)

        view?.provide(chart: chartData)
        view?.provide(data: transactionsViewData)
    }

    func refreshChart() {
        guard let transactions = fetchedTransactionsController.fetchedObjects else {
            return
        }
        chartData = evaluateGraphData(from: transactions)

        view?.provide(chart: chartData)
    }

    func removeTransaction(at index: Int) {
        guard let objects = fetchedTransactionsController.fetchedObjects, index < objects.count else {
            return
        }

        print("///////VC3 delete save")
        context.performChanges {
            self.context.delete(objects[index])
        }
    }

    private func evaluateGraphData(from transactions: [Transaction]) -> [CoinChartData] {
        var coinTempData: [CoinChartData] = []

        for t in transactions {

            guard let index = coinTempData.index(where: {
                $0.coinName == t.coin.fullname
            }) else {
                let newObject = CoinChartData(coinName: t.coin.fullname, quantity: t.quantity, value: t.price.value * t.quantity)
                coinTempData.append(newObject)
                continue
            }

            let object = coinTempData[index]
            coinTempData[index] = CoinChartData(coinName: object.coinName, quantity: object.quantity + t.quantity, value: object.value + t.price.value * t.quantity)
        }

        return coinTempData
    }

    private func buildViewData(from transaction: Transaction) -> TransactionViewData {
        return TransactionViewData(coinImage: transaction.coin.image, coinName: transaction.coin.fullname, type: transaction.type.string, price: transaction.price.value, quantity: transaction.quantity)
    }
}

extension TransactionsListPresenter: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let transaction = anObject as? Transaction else {
            fatalError()
        }

        switch type {
        case .insert:
            let object = buildViewData(from: transaction)
            transactionsViewData.insert(object, at: newIndexPath!.row)
            view?.insert(data: object, at: newIndexPath!.row)
            refreshChart()
        case .delete:
            transactionsViewData.remove(at: indexPath!.row)
            view?.remove(at: indexPath!.row)
            refreshChart()
            return
        default:
            return
        }
    }
}

struct TransactionViewData {
    let coinImage: UIImage?
    let coinName: String

    let type: String
    let price: Float
    let quantity: Float
}

struct CoinChartData {
    let coinName: String

    let quantity: Float
    let value: Float
}
