//
//  TransactionCreatingSession.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData

class TransactionCreatingSession {

    var coin: Coin?
    var type: Transaction.TransactionType?
    var quantity: Float?
    var date: Date?
    var price: Float?
    var currency: Price.CurrencyType?

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    var isComplete: Bool {
        let mirror = Mirror(reflecting: self)

        return !mirror.children.contains(where: {
            if case Optional<Any>.some(_) = $0.value {
                return false
            } else {
                return true
            }
        })
    }

    func getTransaction(completion: @escaping (Transaction?) -> Void) {
        guard isComplete else {
            return completion(nil)
        }

        context.performChanges {
            let transaction = Transaction.insert(into: self.context, coin: self.coin!, type: self.type!, quantity: self.quantity!, date: self.date!, price: self.price!, currencyType: self.currency!)
            completion(transaction)
        }
    }
}
