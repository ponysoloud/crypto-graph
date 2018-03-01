//
//  Transaction+CoreDataProperties.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//
//

import Foundation
import CoreData

extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: Int16
    @NSManaged public var count: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var coin_id: String?

}
