//
//  CoinShortInfoItem.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class CoinShortItem: UITableViewCell {

    static var nibName: String { get { return "CoinShortItem" } }
    static var reuseIdentifier: String { get { return "CoinShortItem" } }

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var coinSymbolLabel: UILabel!

    func setup(with coin: CoinViewData) {
        iconImageView.image = coin.image
        coinNameLabel.text = coin.name
        coinSymbolLabel.text = coin.symbol.uppercased()
    }

    func animateSelection(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            }
            completion()
        })
    }
}
