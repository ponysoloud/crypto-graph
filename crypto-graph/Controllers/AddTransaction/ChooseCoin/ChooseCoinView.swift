//
//  ChooseCoinView.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

protocol ChooseCoinView: class {

    func showLoading(isVisible: Bool)

    func provide(items: [CoinViewData])
    
}
