//
//  Int+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 08.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

extension Int {

    init?(float: Float?) {
        guard let f = float else {
            return nil
        }

        self.init(f)
    }
}
