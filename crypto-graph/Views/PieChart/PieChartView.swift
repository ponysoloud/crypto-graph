//
//  PieChartView.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 10.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

struct Piece {
    let color: UIColor
    let value: CGFloat
    let name: String
}

class PieChartView: UIView {

    var pieces = [Piece]() {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()

        let radius = min(frame.size.width, frame.size.height) * 0.5
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let valueCount = pieces.reduce(0, {$0 + $1.value})

        var startAngle = -CGFloat.pi * 0.5

        for piece in pieces {

            ctx?.setFillColor(piece.color.cgColor)

            let endAngle = startAngle + 2 * .pi * (piece.value / valueCount)

            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

            ctx?.fillPath()

            startAngle = endAngle
        }
    }
}
