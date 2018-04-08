//
//  ConvertCurrencies.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 29.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

struct Convert: Hashable {

    let symbol: String

    var hashValue: Int {
        return symbol.hashValue
    }

    static func ==(lhs: Convert, rhs: Convert) -> Bool {
        return lhs.symbol == rhs.symbol
    }

    static var feauturedConverts: [Convert] = []
}

