//
//  LargeButton.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class LargeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    private func setupStyle() {
        let textSize: CGFloat = 34.0

        self.titleLabel?.font = UIFont.systemFont(ofSize: textSize, weight: .regular)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.setTitleColor(UIColor.black, for: .normal)
        self.setTitleColor(UIColor.gray, for: .highlighted)

        self.contentHorizontalAlignment = .center
        self.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.titleEdgeInsets = UIEdgeInsets.zero
        self.imageEdgeInsets = UIEdgeInsets.zero

        self.backgroundColor = UIColor.yellow
    }

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.green : UIColor.yellow
        }
    }

    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }

    var title: String? {
        return title(for: .normal)
    }

    func getHeightToFitText() -> CGFloat {
        guard let titleLabel = titleLabel else {
            return 45
        }

        return titleLabel.bounds.height + 30
    }

    func animateAppearing(completion: @escaping () -> Void = {}) {
        transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }, completion: { _ in
            completion()
        })
    }

    func animateDisapperating(completion: @escaping () -> Void = {}) {
        transform = CGAffineTransform.identity

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
        }, completion: { _ in
            completion()
        })
    }

}
