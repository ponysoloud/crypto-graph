//
//  ExtendedCoinPrice.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 29.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExtendedCoinPrice: JSONInitializable {

    private(set) var price: [Convert : Float]

    let coinSymbol: String
    let percentChange1h: Float
    let percentChange24h: Float

    struct Keys {
        static let percentChange1h = "percent_change_1h"
        static let percentChange24h = "percent_change_24h"
        static let prices = "prices"
        static let convert = "convert"
        static let value = "value"
        static let symbol = "symbol"
    }

    required init?(json: JSON) {
        guard json[Keys.percentChange1h].exists(), json[Keys.percentChange1h].exists(), json[Keys.prices].exists() else {
            return nil
        }

        coinSymbol = json[Keys.symbol].stringValue
        percentChange1h = json[Keys.percentChange1h].floatValue
        percentChange24h = json[Keys.percentChange24h].floatValue

        price = [:]

        for j in json[Keys.prices].arrayValue {
            guard j[Keys.value].exists(), j[Keys.convert].exists() else {
                return nil
            }

            let convert = Convert(symbol: j[Keys.convert].stringValue)
            let value = j[Keys.value].floatValue

            price[convert] = value
        }
    }
}
