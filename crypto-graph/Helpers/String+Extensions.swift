//
//  String+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 06.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

extension String {

    init?(float: Float?, formatting: Bool = false, prefixing: String? = nil, appending: String? = nil) {
        guard let f = float else {
            return nil
        }

        let format: String

        if f < 1.0 {
            format = "%.3f"
        } else if f < 50.0 {
            format = "%.2f"
        } else if f < 1000 {
            format = "%.1f"
        } else {
            format = "%"
        }

        if formatting {
            self.init(format: format, f)
        } else {
            self.init(f)
        }

        if let a = appending {
            self += a
        }

        if let p = prefixing {
            self = p + self
        }
    }

    init?(int: Int?, prefixing: String? = nil, appending: String? = nil) {
        guard let i = int else {
            return nil
        }

        self.init(i)

        if let a = appending {
            self += a
        }

        if let p = prefixing {
            self = p + self
        }
    }
}
