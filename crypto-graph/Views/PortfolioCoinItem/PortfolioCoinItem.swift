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
    static var height: CGFloat { return 78.0 }

    @IBOutlet private var innerContentView: InnerContentView!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var changeLabel: UILabel!
    @IBOutlet private var profitLabel: UILabel!

    @IBOutlet private var nameWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var priceWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        setupStyle()
        setLayouts()
    }

    func setup(with data: CoinTransactionsViewData) {
        iconImageView.image = data.coinImage
        coinNameLabel.text = data.coinName

        var textColor: UIColor = UIColor(hex: 0x626262)
        var priceSuffix: String = ""

        if let change = data.change1h, let profit = data.profit {
            priceSuffix = change > 0 ? "↗" : "↘"
            textColor = profit > 0 ? UIColor(hex: 0x62d07d) : UIColor(hex: 0xf35467)
        }

        priceLabel.text = String(price: data.currentPrice, formatting: true, appending: priceSuffix)
        changeLabel.text = String(percents: data.change1h)
        profitLabel.text = String(percents: data.profit, formatting: true)
        profitLabel.textColor = textColor
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

    private func setLayouts() {
        switch UIDevice.current.screenType {
        case .extraSmall, .small, .unknown:
            nameWidthConstraint.constant = 50.0
            priceWidthConstraint.constant = 50.0
        case .medium:
            nameWidthConstraint.constant = 62.0
            priceWidthConstraint.constant = 67.0
        case .plus, .extra:
            nameWidthConstraint.constant = 70.0
            priceWidthConstraint.constant = 76.0
        }
        layoutIfNeeded()
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
