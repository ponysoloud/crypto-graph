//
//  Price+CoreDataClass.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Price)
final class Price: NSManagedObject {

    @NSManaged private(set) var value: Float
    @NSManaged private(set) var currencyTypeValue: Int16
    @NSManaged private(set) var transaction: Transaction

    enum CurrencyType: Int16 {
        case btc = 0, usd, eur, rub
    }

    var currencyType: CurrencyType {
        get {
            return CurrencyType(rawValue: currencyTypeValue) ?? .usd
        }
        set {
            currencyTypeValue = newValue.rawValue
        }
    }

    convenience init(into context: NSManagedObjectContext, value: Float, currencyType: CurrencyType) {
        guard let entity = NSEntityDescription.entity(forEntityName: Price.entityName, in: context) else {
            fatalError("Wrong type")
        }

        self.init(entity: entity, insertInto: context)

        self.value = value
        self.currencyType = currencyType
    }
}

extension Price: Managed {
    
}
