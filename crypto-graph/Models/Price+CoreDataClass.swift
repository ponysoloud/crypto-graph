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

@objc(Price)
final class Price: NSManagedObject, Managed, ManagedObjectJSONInitializable {

    struct Keys {
        static let btc = "price_btc"
        static let usd = "price_usd"
    }

    init?(in context: NSManagedObjectContext, with json: JSON, contextDisconnected: Bool) {

        guard let description = NSEntityDescription.entity(forEntityName: Price.entityName, in: context),
            let json = json as? [String: String] else {
                return nil
        }

        super.init(entity: description, insertInto: contextDisconnected ? nil : context)
        
        self.btc_price = json[Keys.btc]!.toFloat()!
        self.usd_price = json[Keys.usd]!.toFloat()!
    }
}
