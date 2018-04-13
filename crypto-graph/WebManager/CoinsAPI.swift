//
//  CoinsAPI.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 27.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import CoreData

final class CoinsAPI: APIEndpoint {

    override var baseURL: String {
        //return "http://127.0.0.1:5000"

        return "https://crypto-graph-api.herokuapp.com"
    }

    override var mapper: Mapper? {
        return Mapper(context: context)
    }

    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAllCoins(rankFrom: Int = 1, rankTo: Int = 0, query: String = "", limits: Int = 10, success: @escaping ([Coin]) -> Void, failure: @escaping (RequestError) -> Void) {

        let parameters = ["rank.gte": "\(rankFrom)", "rank.lte": "\(rankTo)", "query": "\(query)", "limits": "\(limits)"]
        request(path: "coins", parameters: parameters, success: success, failure: failure)
    }

    func fetchCoin(by symbol: String, success: @escaping (Coin) -> Void, failure: @escaping (RequestError) -> Void) {
        if let coin = Coin.getManagedObject(by: symbol, in: context) {
            return success(coin)
        }
        request(path: "coins/coin/\(symbol)", parameters: [:], success: success, failure: failure)
    }

    func fetchCoinPrice(by symbol: String, for convert: Convert, success: @escaping (ExtendedCoinPrice) -> Void, failure: @escaping (RequestError) -> Void) {

        let parameters = ["convert": convert.symbol]
        request(path: "coins/coin/price/\(symbol)", parameters: parameters, success: success, failure: failure)
    }

    func fetchCoinPrice(_ coin: Coin, success: @escaping (Coin) -> Void, failure: @escaping (RequestError) -> Void) {

        let succ: (ExtendedCoinPrice) -> Void = {
            coin.updatePrice(with: $0)
            success(coin)
        }

        request(path: "coins/coin/price/\(coin.symbol)", parameters: [:], success: succ, failure: failure)
    }
    

}
