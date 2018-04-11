//
//  CGFloat+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 10.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

extension CGFloat {
    func radians() -> CGFloat {
        let b = .pi * (self/180)
        return b
    }
}
