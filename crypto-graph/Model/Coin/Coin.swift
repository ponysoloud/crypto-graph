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
import SwiftyJSON

@objc(Coin)
final class Coin: NSManagedObject, ManagedContextInitializable {

    @NSManaged private(set) var id: Int64
    @NSManaged private(set) var imageUrlString: String
    @NSManaged private(set) var imageData: NSData?
    @NSManaged private(set) var name: String
    @NSManaged private(set) var rank: Int64
    @NSManaged private(set) var symbol: String
    @NSManaged private(set) var fullname: String
    @NSManaged public private(set) var transactions: Set<Transaction>

    private(set) var percentChange1h: Float?
    private(set) var percentChange24h: Float?
    private(set) var price: Float?

    private(set) var image: UIImage? {
        get {
            guard let imageData = imageData as Data? else {
                return nil
            }
            return UIImage(data: imageData)
        }
        set {
            if let new = newValue {
                imageData = UIImagePNGRepresentation(new) as NSData?
            }
        }
    }

    struct Keys {
        static let id = "id"
        static let name = "name"
        static let symbol = "symbol"
        static let rank = "rank"
        static let fullname = "fullname"
        static let image = "img_url"
    }

    convenience init?(into context: NSManagedObjectContext, json: JSON) {
        guard let entity = NSEntityDescription.entity(forEntityName: Coin.entityName, in: context) else {
            fatalError("Wrong type")
        }

        guard json[Keys.id].exists(), json[Keys.name].exists(), json[Keys.symbol].exists(), json[Keys.rank].exists() else {
            return nil
        }

        self.init(entity: entity, insertInto: context)

        self.id = json[Keys.id].int64Value
        self.name = json[Keys.name].stringValue
        self.symbol = json[Keys.symbol].stringValue
        self.rank = json[Keys.rank].int64Value
        self.fullname = json[Keys.fullname].stringValue
        self.imageUrlString = json[Keys.image].stringValue

    }

    static func updateManagedObject(with json: JSON, in context: NSManagedObjectContext) -> Coin? {
        guard let id = json[Keys.id].int64,
            json[Keys.name].exists(),
            json[Keys.symbol].exists(),
            json[Keys.rank].exists(),
            json[Keys.fullname].exists(),
            json[Keys.image].exists()
            else {
            return nil
        }

        let predicate = NSPredicate(format: "\(#keyPath(Coin.id)) == %d", Int(id))

        return Coin.getManaged(in: context, matching: predicate, configureExisting: {
            $0.rank = json[Keys.rank].int64Value
        }, configureNew: { new in
            new.id = id
            new.name = json[Keys.name].stringValue
            new.symbol = json[Keys.symbol].stringValue
            new.rank = json[Keys.rank].int64Value
            new.fullname = json[Keys.fullname].stringValue
            new.imageUrlString = json[Keys.image].stringValue

            if let url = URL(string: new.imageUrlString) {
                ImageManager.getImageForManagedObject(into: context, from: url, completion: { image in
                    new.image = image
                })
            }
        })
    }

    static func getManagedObject(by symbol: String, in context: NSManagedObjectContext) -> Coin? {
        let predicate = NSPredicate(format: "\(#keyPath(Coin.symbol)) == %@", symbol)

        return Coin.getManaged(in: context, matching: predicate)
    }

    func updatePrice(with fetchedPrice: ExtendedCoinPrice) {
        percentChange1h = fetchedPrice.percentChange1h
        percentChange24h = fetchedPrice.percentChange24h

        let usd = Convert(symbol: "USD")
        price = fetchedPrice.price[usd]
    }
}

extension Coin: Managed {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(rank), ascending: false)]
    }

}
