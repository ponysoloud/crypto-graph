//
//  CustomNavigationTransitionController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 09.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class CustomTransitioningNavigationController: UINavigationController {

    var customTransitionCoordinator: TransitionCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = customTransitionCoordinator
        self.delegate = customTransitionCoordinator
    }
}
