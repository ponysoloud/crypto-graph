//
//  UIDevice+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 11.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case extraSmall = "iPhone 4 or iPhone 4S"
        case small = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case medium = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case extra = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .extraSmall
        case 1136:
            return .small
        case 1334:
            return .medium
        case 1920, 2208:
            return .plus
        case 2436:
            return .extra
        default:
            return .unknown
        }
    }
}

