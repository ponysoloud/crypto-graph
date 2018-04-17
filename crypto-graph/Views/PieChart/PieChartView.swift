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

    /// Defines whether the segment labels should be shown when drawing the pie chart
    var showSegmentLabels = true {
        didSet { setNeedsDisplay() }
    }

    /// Defines whether the segment labels will show the value of the segment in brackets
    var showSegmentValueInLabel = false {
        didSet { setNeedsDisplay() }
    }

    /// The font to be used on the segment labels
    var segmentLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium) {
        didSet {
            textAttributes[NSAttributedStringKey.font] = segmentLabelFont
            setNeedsDisplay()
        }
    }

    private let paragraphStyle : NSParagraphStyle = {
        var p = NSMutableParagraphStyle()
        p.alignment = .center
        return p.copy() as! NSParagraphStyle
    }()

    private lazy var textAttributes : [NSAttributedStringKey : Any] = {
        return [NSAttributedStringKey.paragraphStyle : self.paragraphStyle, NSAttributedStringKey.font : self.segmentLabelFont]
    }()

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

        for piece in pieces {

            guard piece.value / valueCount > 0.1 else {
                continue
            }

            let endAngle = startAngle + 2 * .pi * (piece.value / valueCount)

            ctx?.move(to: viewCenter)

            if showSegmentLabels { // do text rendering

                let halfAngle = startAngle + (endAngle - startAngle) * 0.5;

                let textPositionValue : CGFloat = 0.8

                let segmentCenter = CGPoint(x: viewCenter.x + radius * textPositionValue * cos(halfAngle), y: viewCenter.y + radius * textPositionValue * sin(halfAngle))

                let textToRender = showSegmentValueInLabel ? " \(piece.name)\n $\(piece.value.formattedToOneDecimalPlace)" : piece.name

                textAttributes[NSAttributedStringKey.foregroundColor] = UIColor.darkGray

                var renderRect = CGRect(origin: .zero, size: textToRender.size(withAttributes: textAttributes))

                if pieces.count > 1 {
                    renderRect.origin = CGPoint(x: segmentCenter.x - renderRect.size.width * 0.5, y: segmentCenter.y - renderRect.size.height * 0.5)
                } else {
                    renderRect.origin = CGPoint(x: viewCenter.x - renderRect.size.width / 2, y: viewCenter.y - renderRect.size.height / 2)
                }

                textToRender.draw(in: renderRect, withAttributes: textAttributes)
            }

            startAngle = endAngle
        }
    }
}
