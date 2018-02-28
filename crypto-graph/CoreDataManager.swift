//
//  CoreDataHelper.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 25.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Properties

    private let modelName: String

    // MARK: - Initialization

    init(modelName: String) {
        self.modelName = modelName
    }

    // MARK: - Core Data Stack

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    let lockQueue = DispatchQueue(label: "com.test.LockQueue", attributes: [])

    func save() {
        lockQueue.sync {
            [weak self] in
            self?.context.perform({
                [weak self] in
                do {
                    try self?.context.save()
                } catch let error {
                    print(error)
                }
            })
        }
    }

    func deleteFromStore(_ object: NSManagedObject, save s: Bool = true) {
        lockQueue.sync {
            [weak self] in
            self?.context.perform({
                [weak self] in
                self?.context.delete(object)
                if s == true {
                    self?.save()
                }
            })
        }
    }

    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
