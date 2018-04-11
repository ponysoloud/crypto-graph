//
//  MyPortfolio.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

protocol PortfolioView: class {

    func provide(data: [CoinTransactionsViewData])

    func append(_ newObject: CoinTransactionsViewData)

    func updateObject(existingAt index: Int, with object: CoinTransactionsViewData)

    func updateHeader(with object: TotalTransactionsViewData)

    func remove(at index: Int)

    func show(placeholder message: String, isVisible: Bool)
}
