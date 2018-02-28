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
public class Price: NSManagedObject {

    struct Keys {
        static let btc = "price_btc"
        static let usd = "price_usd"
    }

    convenience init?(in context: NSManagedObjectContext, with json: JSON?) {
        guard let json = json else { return nil }

        self.init(context: context)

        btc_price = (json[Keys.btc] as! String).toFloat()!
        usd_price = (json[Keys.usd] as! String).toFloat()!
    }

    convenience init(in context: NSManagedObjectContext, btc: Float) {
        self.init(context: context)

        btc_price = btc
    }

    convenience init(in context: NSManagedObjectContext, usd: Float) {
        self.init(context: context)

        usd_price = usd
    }
}
