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
        totalValueLabel.text = String(int: Int(float: data.currentCost), prefixing: "$")
        totalCostLabel.text = String(int: Int(float: data.cost), prefixing: "$")
        totalProfitLabel.text = String(float: data.profit, appending: "%")
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
