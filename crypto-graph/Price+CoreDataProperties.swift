//
//  Price+CoreDataProperties.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//
//

import Foundation
import CoreData

extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price")
    }

    @NSManaged public var btc_price: Float
    @NSManaged public var usd_price: Float

}
