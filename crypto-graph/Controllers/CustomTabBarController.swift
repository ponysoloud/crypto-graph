//
//  CustomTabBarController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 04.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarChildViewController {

    var controllerInstantinationToPresent: UIViewController? { get }

}

extension TabBarChildViewController {

    var controllerInstantinationToPresent: UIViewController? {
        return nil
    }

}

enum ItemPresentationStyle {
    case onlyImage, imageAndTitle
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    var itemsPresentationsStyle: ItemPresentationStyle = .imageAndTitle {
        didSet {
            presentationStyleChanged(to: itemsPresentationsStyle)
        }
    }

    func setViewControllers(_ viewControllers: [TabBarChildViewController]) {
        let vcs = viewControllers.flatMap {
            $0 as? UIViewController
        }

        self.setViewControllers(vcs, animated: true)

        presentationStyleChanged(to: itemsPresentationsStyle)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let target = viewController as? TabBarChildViewController, let vc = target.controllerInstantinationToPresent else {
            return true
        }

        // TODO: - Todo

        /*
        let vc = ControllerHelper.instantiateViewController(identifier: "AddTransactionNavigationController") as! AddTransactionNavigationController

        vc.presenter = AddTransactionPresenter(view: vc, transactionCreatingSession: TransactionCreatingSession(context: CoreDataManager.shared.context), coinsAPI: CoinsAPI(context: CoreDataManager.shared.context)) */

        self.present(vc, animated: true, completion: nil)
        return false
    }

    private func presentationStyleChanged(to style: ItemPresentationStyle) {
        guard let vcs = viewControllers else {
            return
        }

        vcs.forEach { vc in
            switch itemsPresentationsStyle {
            case .onlyImage:
                vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 50);
            case .imageAndTitle:
                vc.tabBarItem.imageInsets = UIEdgeInsets.zero
                vc.tabBarItem.titlePositionAdjustment = UIOffset.zero
            }
        }
    }
}
