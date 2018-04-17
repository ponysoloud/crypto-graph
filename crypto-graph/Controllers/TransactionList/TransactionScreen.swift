//
//  TransactionScreen.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 17.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class TransactionScreen: UIViewController {

    var transactionItem: TransactionViewData?

    @IBOutlet private var contentView: InnerContentView!

    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var transactionTypeLabel: UILabel!
    @IBOutlet private var priceHeaderLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var marketLabel: UILabel!

    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let transactionItem = transactionItem else {
            return
        }

        coinNameLabel.text = transactionItem.coinName
        transactionTypeLabel.text = transactionItem.type
        priceHeaderLabel.text = "\(transactionItem.type) price"
        priceLabel.text = String(price: transactionItem.price)
        amountLabel.text = String(transactionItem.quantity)
        marketLabel.text = transactionItem.market
        dateLabel.text = transactionItem.date

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

