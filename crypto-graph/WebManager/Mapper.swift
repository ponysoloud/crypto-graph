//
//  Mapper.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 28.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import CoreData
import SwiftyJSON

protocol Mappable { }

struct Mapper {

    let context: NSManagedObjectContext

    func map<T: Mappable>(json: JSON, completion: @escaping (T?) -> Void) {
        if let t = T.self as? ManagedContextInitializable.Type {
            context.performChanges {
                let managed = t.updateManagedObject(with: json, in: self.context) as? T
                return completion(managed)
            }
        }

        if let t = T.self as? JSONInitializable.Type {
            let object = t.init(json: json) as? T
            return completion(object)
        }
    }
}
