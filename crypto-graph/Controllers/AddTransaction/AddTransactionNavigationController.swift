//
//  AddTransactionNavigationController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 04.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

protocol AddTransactionNavigationControllerDelegate: class {

    func completeChoosingCoinStep()

    func completeEnteringDetailsStep()

    func leave()
}

class AddTransactionNavigationController: UINavigationController, TabBarChildViewController {

    var controllerInstantinationToPresent: UIViewController? {
        let vc = ControllerHelper.instantiateViewController(identifier: "AddTransactionNavigationController") as! AddTransactionNavigationController

        vc.presenter = AddTransactionPresenter(view: vc, transactionCreatingSession: TransactionCreatingSession(context: CoreDataManager.shared.context), coinsAPI: CoinsAPI(context: CoreDataManager.shared.context))

        return vc
    }

    var presenter: AddTransactionPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.showRootScreen()
    }
}

extension AddTransactionNavigationController: AddTransactionNavigationControllerDelegate {

    func completeChoosingCoinStep() {
        presenter?.completeChoosingCoin()
    }

    func completeEnteringDetailsStep() {
        presenter?.completeEnteringDetails()
    }

    func leave() {
        self.dismiss(animated: true)
    }

}

extension AddTransactionNavigationController: AddTransactionView {

    func showChooseCoinScreen(with creatingSession: TransactionCreatingSession, coinsAPI: CoinsAPI) {
        let _chooseCoinScreen = ControllerHelper.instantiateViewController(identifier: "ChooseCoinViewController")

        guard let chooseCoinScreen = _chooseCoinScreen as? ChooseCoinViewController else {
            fatalError()
        }

        chooseCoinScreen.presenter = ChooseCoinPresenter(view: chooseCoinScreen, transactionCreatingSession: creatingSession, coinsAPI: coinsAPI)

        chooseCoinScreen.transactionDelegate = self

        self.pushViewController(chooseCoinScreen, animated: true)
    }

    func showEnterDetailsScreen(with creatingSession: TransactionCreatingSession) {
        let _detailsScreen = ControllerHelper.instantiateViewController(identifier: "EnterTransactionDetailsViewController")

        guard let detailsScreen = _detailsScreen as? EnterTransactionDetailsViewController else {
            fatalError()
        }

        detailsScreen.presenter = EnterTransactionDetailsPresenter(view: detailsScreen, transactionCreatingSession: creatingSession)

        detailsScreen.transactionDelegate = self

        self.pushViewController(detailsScreen, animated: true)
    }

    func complete() {
        self.dismiss(animated: true)
    }

}
