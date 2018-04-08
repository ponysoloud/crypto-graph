//
//  ManagedContextInitializable.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 28.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import CoreData
import SwiftyJSON

protocol ManagedContextInitializable: Mappable {

    init?(into context: NSManagedObjectContext, json: JSON)

    static func updateManagedObject(with json: JSON, in context: NSManagedObjectContext) -> Self?

}
