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
    @IBOutlet private var changeLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var costLabel: UILabel!
    @IBOutlet private var currentValueLabel: UILabel!
    @IBOutlet private var profitLabel: UILabel!

    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let portfolioItem = portfolioItem else {
            return
        }

        backButton.addTarget(self, action: #selector(moveBack(_:)), for: .touchUpInside)

        iconImageView.image = portfolioItem.coinImage
        coinNameLabel.text = portfolioItem.coinName
        currentPriceLabel.text = String(float: portfolioItem.currentPrice, formatting: true, prefixing: "$", appending: "")
        changeLabel.text = String(float: portfolioItem.change1h, appending: "%")
        amountLabel.text = String(portfolioItem.amount)
        costLabel.text = String(portfolioItem.cost)
        currentValueLabel.text = String(float: portfolioItem.currentCost, prefixing: "$")
        profitLabel.text = String(float: portfolioItem.profit, appending: "%")

        contentView.layer.cornerRadius = 6.0

        contentView.clipsToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.05
    }

    @objc
    private func moveBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
