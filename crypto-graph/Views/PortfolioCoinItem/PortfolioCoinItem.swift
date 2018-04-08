//
//  PortfolioCoinItem.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 06.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class PortfolioCoinItem: UITableViewCell {

    static var nibName: String { return "PortfolioCoinItem" }
    static var reuseIdentifier: String { return "PortfolioCoinItem" }
    static var height: Float { return 77.0 }

    @IBOutlet private var innerContentView: UIView!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var changeLabel: UILabel!
    @IBOutlet private var profitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        setupStyle()
    }

    func setup(with data: CoinTransactionsViewData) {
        iconImageView.image = data.coinImage
        coinNameLabel.text = data.coinName
        priceLabel.text = String(float: data.currentPrice, formatting: true, prefixing: "$", appending: "↘")
        changeLabel.text = String(float: data.change1h, appending: "%")
        profitLabel.text = String(float: data.profit, appending: "%")
    }

    func animateSelection(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            self.innerContentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.innerContentView.layer.shadowOpacity = 0.01
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.innerContentView.transform = CGAffineTransform.identity
                self.innerContentView.layer.shadowOpacity = 0.05
            }
            completion()
        })
    }

    private func setupStyle() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.0)

        self.clipsToBounds = false
        self.contentView.clipsToBounds = false

        self.innerContentView.layer.cornerRadius = 6.0

        self.innerContentView.clipsToBounds = false
        self.innerContentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.innerContentView.layer.shadowRadius = 5
        self.innerContentView.layer.shadowOpacity = 0.05
    }

}

class InnerContentView: UIView {

    override var bounds: CGRect {
        didSet {
            super.bounds = bounds
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 6.0).cgPath
        }
    }
    
}
