//
//  TransactionsChart.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 10.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class TransactionsChart: UITableViewCell {

    static var nibName: String { return "TransactionsChart" }
    static var reuseIdentifier: String { return "TransactionsChart" }
    static var height: Float { return 300.0 }

    @IBOutlet private var innerContentView: InnerContentView!
    @IBOutlet private var pieChartView: PieChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        setupStyle()
    }

    func setup(with chartPieces: [Piece]) {
        pieChartView.pieces = chartPieces
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
