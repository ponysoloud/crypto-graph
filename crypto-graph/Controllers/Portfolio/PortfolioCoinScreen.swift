//
//  PortfolioCoinScreen.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 06.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class PortfolioCoinScreen: UIViewController {

    var portfolioItem: CoinTransactionsViewData?

    @IBOutlet private var contentView: InnerContentView!

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var currentPriceLabel: UILabel!
    @IBOutlet private var averagePriceLabel: UILabel!
    @IBOutlet private var changeLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var costLabel: UILabel!
    @IBOutlet private var currentValueLabel: UILabel!
    @IBOutlet private var profitLabel: UILabel!
    @IBOutlet private var marketLabel: UILabel!

    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let portfolioItem = portfolioItem else {
            return
        }

        iconImageView.image = portfolioItem.coinImage
        coinNameLabel.text = portfolioItem.coinName

        var textColor: UIColor = UIColor(hex: 0x626262)
        var priceSuffix: String = ""

        if let change = portfolioItem.change1h, let profit = portfolioItem.profit {
            priceSuffix = change > 0 ? "↗" : "↘"
            textColor = profit > 0 ? UIColor(hex: 0x62d07d) : UIColor(hex: 0xf35467)
        }

        currentPriceLabel.text = String(price: portfolioItem.currentPrice, appending: priceSuffix)
        averagePriceLabel.text = String(price: portfolioItem.avgBuyPrice)
        changeLabel.text = String(percents: portfolioItem.change1h)
        marketLabel.text = portfolioItem.market
        amountLabel.text = String(portfolioItem.amount)
        costLabel.text = String(price: portfolioItem.cost)
        currentValueLabel.text = String(price: portfolioItem.currentCost)
        profitLabel.text = String(percents: portfolioItem.profit)
        profitLabel.textColor = textColor

        contentView.layer.cornerRadius = 6.0

        contentView.clipsToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.05

        backButton.addTarget(self, action: #selector(moveBack(_:)), for: .touchUpInside)
    }

    @objc
    private func moveBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
