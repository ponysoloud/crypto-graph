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
final class Cryptocurrency: NSManagedObject, ManagedObjectJSONInitializable {

    struct Keys {
        static let id = "id"
        static let name = "name"
        static let symbol = "symbol"
        static let rank = "rank"
    }

    init?(in context: NSManagedObjectContext, with json: JSON, contextDisconnected: Bool) {

        guard let description = NSEntityDescription.entity(forEntityName: Cryptocurrency.entityName, in: context)
            , let json = json as? [String: String] else {
            return nil
        }

        super.init(entity: description, insertInto: contextDisconnected ? nil : context)

        self.id = json[Keys.id]!
        self.name = json[Keys.name]!
        self.symbol = json[Keys.symbol]!
        self.rank = json[Keys.rank]!.toInt16()!
        self.current_price = Price(in: context, with: json, contextDisconnected: contextDisconnected)!

        transactions_ids = []
    }

}

extension Cryptocurrency: Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(rank), ascending: false)]
    }

}
