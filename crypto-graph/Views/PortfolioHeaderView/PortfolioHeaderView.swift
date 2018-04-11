//
//  PortfolioHeaderView.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 08.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class PortfolioHeaderView: UIView {

    static var nibName: String { return "PortfolioHeaderView" }
    static var height: Float { return 77.0 }

    class func instanceFromNib() -> PortfolioHeaderView {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PortfolioHeaderView
    }

    @IBOutlet private var totalValueLabel: UILabel!
    @IBOutlet private var totalCostLabel: UILabel!
    @IBOutlet private var totalProfitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    func setup(with data: TotalTransactionsViewData) {
        var textColor: UIColor = UIColor(hex: 0x626262)

        if let profit = data.profit {
            textColor = profit > 0 ? UIColor(hex: 0x62d07d) : UIColor(hex: 0xf35467)
        }

        totalValueLabel.text = String(price: data.currentCost, rounding: true)
        totalCostLabel.text = String(price: data.cost, rounding: true)
        totalProfitLabel.text = String(percents: data.profit, formatting: true)
        totalProfitLabel.textColor = textColor
    }

    private func setupStyle() {
        self.layer.cornerRadius = 10.0

        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.10
    }

    override var bounds: CGRect {
        didSet {
            super.bounds = bounds
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10.0).cgPath
        }
    }

}
