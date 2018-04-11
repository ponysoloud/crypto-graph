//
//  String+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 06.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

extension String {

    init(percents: Float?, formatting: Bool = true) {
        guard let f = percents else {
            self.init()
            self = "-"
            return
        }

        let temp = abs(f)
        let format: String

        if temp < 1.0 {
            format = "%.2f"
        } else if temp < 50.0 {
            format = "%.1f"
        } else {
            format = "%.0f"
        }

        if formatting {
            self.init(format: format, f)
        } else {
            self.init(f)
        }

        let suffix = "%"
        let prefix = "+"

        if f > 0 {
            self = prefix + self
        }

        self += suffix
    }

    init(price: Float?, formatting: Bool = true, appending suffix: String? = nil) {
        guard let f = price else {
            self.init()
            self = "-"
            return
        }

        let format: String

        if f < 1.0 {
            format = "%.3f"
        } else if f < 50.0 {
            format = "%.2f"
        } else if f < 1000.0 {
            format = "%.1f"
        } else {
            format = "%.0f"
        }

        if formatting {
            self.init(format: format, f)
        } else {
            self.init(f)
        }

        let prefix = "$"
        self = prefix + self

        if let suf = suffix {
            self += suf
        }
    }

    init(price: Float?, rounding: Bool) {
        guard let f = price else {
            self.init()
            self = "-"
            return
        }

        let rounded = Int(f)
        self.init(rounded)

        let prefix = "$"
        self = prefix + self
    }

    init?(float: Float?, prefixing: String? = nil, appending: String? = nil) {
        guard let f = float else {
            return nil
        }

        self.init(f)

        if let a = appending {
            self += a
        }

        if let p = prefixing {
            self = p + self
        }
    }
}
