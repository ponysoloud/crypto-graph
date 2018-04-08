//
//  Managed.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 26.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}


extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] { return [] }

    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }

    public static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        request.predicate = predicate
        return request
    }
}


extension Managed where Self: NSManagedObject {

    static var entityName: String { return entity().name!  }

    static func fetch(in context: NSManagedObjectContext, configuration: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configuration(request)
        return try! context.fetch(request)
    }

    static func getManaged(in context: NSManagedObjectContext, matching predicate: NSPredicate, configureExisting: ((Self) -> ())? = nil, configureNew: (Self) -> ()) -> Self {

        if let object = fetch(in: context, configuration: { request in
            request.predicate = predicate
            request.fetchLimit = 1
        }).first {
            configureExisting?(object)
            return object
        }

        let newObject: Self = context.insertObject()
        configureNew(newObject)
        return newObject
    }

    static func getManaged(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        if let object = fetch(in: context, configuration: { request in
            request.predicate = predicate
            request.fetchLimit = 1
        }).first {
            return object
        }

        return nil
    }
}
