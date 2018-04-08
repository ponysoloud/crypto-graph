//
//  Transaction+CoreDataClass.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Transaction)
final class Transaction: NSManagedObject {

    @NSManaged private(set) var quantity: Float
    @NSManaged private(set) var date: Date
    @NSManaged private(set) var typeValue: Int16
    @NSManaged private(set) var coin: Coin
    @NSManaged private(set) var price: Price

    enum TransactionType: Int16 {
        case buy = 0, sell = 1
    }

    var type: TransactionType {
        get {
            return TransactionType(rawValue: typeValue) ?? .buy
        }
        set {
            typeValue = newValue.rawValue
        }
    }

    static func insert(into context: NSManagedObjectContext, coin: Coin, type: TransactionType, quantity: Float, date: Date, price: Float, currencyType: Price.CurrencyType) -> Transaction {

        let transaction: Transaction = context.insertObject()
        transaction.type = type
        transaction.quantity = quantity
        transaction.date = date

        transaction.coin = coin
        transaction.price = Price(into: context, value: price, currencyType: currencyType)

        return transaction
    }

}

extension Transaction: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}
