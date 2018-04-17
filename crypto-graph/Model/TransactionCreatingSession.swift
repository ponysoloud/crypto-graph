//
//  TransactionCreatingSession.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData

protocol TransactionCreatingSessionDelegate: class {

    func creatingSession(_ creatingSession: TransactionCreatingSession, isComplete: Bool)
}

class TransactionCreatingSession {

    weak var delegate: TransactionCreatingSessionDelegate?

    var coin: Coin? {
        get {
            return propertiesDict[.CoinKey] as? Coin
        }
        set {
            if let new = newValue {
                propertiesDict[.CoinKey] = new
            } else {
                propertiesDict.removeValue(forKey: .CoinKey)
            }
        }
    }
    var type: Transaction.TransactionType? {
        get {
            return propertiesDict[.TypeKey] as? Transaction.TransactionType
        }
        set {
            if let new = newValue {
                propertiesDict[.TypeKey] = new
            } else {
                propertiesDict.removeValue(forKey: .TypeKey)
            }
        }
    }
    var quantity: Float? {
        get {
            return propertiesDict[.QuantityKey] as? Float
        }
        set {
            if let new = newValue {
                propertiesDict[.QuantityKey] = new
            } else {
                propertiesDict.removeValue(forKey: .QuantityKey)
            }
        }
    }
    var date: Date? {
        get {
            return propertiesDict[.DateKey] as? Date
        }
        set {
             if let new = newValue {
                propertiesDict[.DateKey] = new
             } else {
                propertiesDict.removeValue(forKey: .DateKey)
            }
        }
    }
    var price: Float? {
        get {
            return propertiesDict[.PriceKey] as? Float
        }
        set {
            if let new = newValue {
                propertiesDict[.PriceKey] = new
            } else {
                propertiesDict.removeValue(forKey: .PriceKey)
            }
        }
    }
    var market: String? {
        get {
            return propertiesDict[.MarketKey] as? String
        }
        set {
            if let new = newValue {
                propertiesDict[.MarketKey] = new
            } else {
                propertiesDict.removeValue(forKey: .MarketKey)
            }
        }
    }
    var currency: Price.CurrencyType = .usd

    enum PropertiesKey: Int {
        case CoinKey = 0, TypeKey, QuantityKey, DateKey, PriceKey, MarketKey
    }

    private var propertiesDict: [PropertiesKey: Any] = [:] {
        didSet {
            delegate?.creatingSession(self, isComplete: isComplete)
        }
    }
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    var isComplete: Bool {
        for i in 0...5 {
            guard let key = PropertiesKey(rawValue: i), let value = propertiesDict[key] else {
                print("Error for: \(PropertiesKey(rawValue: i)!)")
                return false
            }

            print(key)
            print(value)
        }

        return true
    }

    func getTransaction(completion: @escaping (Transaction?) -> Void) {
        guard isComplete else {
            return completion(nil)
        }

        context.performChanges {
            let transaction = Transaction.insert(into: self.context, coin: self.coin!, type: self.type!, quantity: self.quantity!, date: self.date!, price: self.price!, market: self.market!, currencyType: self.currency)
            completion(transaction)
        }
    }

    func clearDetails() {
        type = nil
        quantity = nil
        date = nil
        price = nil
    }
}
