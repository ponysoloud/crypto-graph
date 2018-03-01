//
//  JSONInitializable.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData

typealias JSON = [String: Any]

protocol ManagedObjectJSONInitializable {

    init?(in context: NSManagedObjectContext, with json: JSON, contextDisconnected: Bool)
    //func update(json: JSON)

}
