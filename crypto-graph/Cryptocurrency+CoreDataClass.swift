//
//  Cryptocurrency+CoreDataClass.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Cryptocurrency)
class Cryptocurrency: NSManagedObject, ManagedObjectJSONInitializable {

    struct Keys {
        static let id = "id"
        static let name = "name"
        static let symbol = "symbol"
        static let rank = "rank"
    }

    convenience required public init?(in context: NSManagedObjectContext, with json: JSON?) {
        guard let json = json else { return nil }

        self.init(context: context)

        id = json[Keys.id] as! String!
        name = json[Keys.name] as! String!
        symbol = json[Keys.symbol] as! String!
        rank = (json[Keys.rank] as! String).toInt16()!

        transactions_ids = []

        current_price = Price(in: context, with: json)!
    }

}

extension Cryptocurrency: Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(rank), ascending: false)]
    }

}
