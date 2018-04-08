//
//  PortfolioNavigationController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 06.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class PortfolioNavigationController: CustomTransitioningNavigationController, TabBarChildViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.isTranslucent = true

        self.isNavigationBarHidden = true


    }

}
