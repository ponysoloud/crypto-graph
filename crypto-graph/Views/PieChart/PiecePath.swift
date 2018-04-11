//
//  PiecePath.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 10.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

class PiecePath: UIBezierPath {

    init(pieChartCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
    {
        super.init()
        self.move(to: center)
        self.addArc(withCenter: center, radius:radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        self.close()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
