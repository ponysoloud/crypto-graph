//
//  TransactionItem.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 10.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

protocol TransactionItemDelegate: class {

    func transactionItemDidTapRemove(_ transactionItem: TransactionItem)
}

class TransactionItem: UITableViewCell {
    static var nibName: String { return "TransactionItem" }
    static var reuseIdentifier: String { return "TransactionItem" }
    static var height: Float { return 77.0 }

    @IBOutlet private var innerContentView: InnerContentView!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var coinNameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var quantityLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!

    @IBOutlet private var removeButton: UIButton!

    @IBOutlet private var nameWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var priceWidthConstraint: NSLayoutConstraint!

    @IBOutlet private var quantityAndTypeContraint: NSLayoutConstraint!
    
    weak var delegate: TransactionItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        setupStyle()
        setLayouts()
    }

    func setup(with data: TransactionViewData) {
        iconImageView.image = data.coinImage
        coinNameLabel.text = data.coinName

        priceLabel.text = String(price: data.price, formatting: true)
        quantityLabel.text = String(data.quantity)
        typeLabel.text = data.type

        removeButton.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
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

    @objc
    private func removeItem(_ sender: Any) {
        delegate?.transactionItemDidTapRemove(self)
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
            quantityAndTypeContraint.constant = 10.0
        case .medium:
            nameWidthConstraint.constant = 60.0
            priceWidthConstraint.constant = 55.0
            quantityAndTypeContraint.constant = 15.0
        case .plus, .extra:
            nameWidthConstraint.constant = 70.0
            priceWidthConstraint.constant = 75.0
            quantityAndTypeContraint.constant = 30.0
        }
        layoutIfNeeded()
    }
}
