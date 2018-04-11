//
//  TransactionsList.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

protocol TransactionsListView: class {

    func provide(data: [TransactionViewData])

    func provide(chart data: [CoinChartData])

    func insert(data: TransactionViewData, at index: Int)

    func remove(at index: Int)

    func show(placeholder message: String)
    
}
