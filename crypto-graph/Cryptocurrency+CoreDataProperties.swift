//
//  Cryptocurrency+CoreDataProperties.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 26.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//
//

import Foundation
import CoreData


extension Cryptocurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cryptocurrency> {
        return NSFetchRequest<Cryptocurrency>(entityName: "Cryptocurrency")
    }

    @NSManaged public var id: String?
    @NSManaged public var img_url: URL?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var rank: Int16
    @NSManaged public var transactions_ids: [Int16]?
    @NSManaged public var current_price: Price?

}
