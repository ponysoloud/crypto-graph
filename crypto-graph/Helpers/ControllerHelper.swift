//
//  ControllerHelper.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

struct ControllerHelper {
    static func getTopViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
            topVC = topVC!.presentedViewController
        }
        return topVC
    }

    static func instantiateViewController(identifier id: String, storyboardName: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
    }
}
