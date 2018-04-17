//
//  AppDelegate.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 22.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var presenter: PortfolioPresenter!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        UINavigationBar.appearance().shadowImage = UIImage()

        window = UIWindow(frame: UIScreen.main.bounds)

        let _portfolioVC = ControllerHelper.instantiateViewController(identifier: "PortfolioNavigationController")
        guard let portfolioVC = _portfolioVC as? PortfolioNavigationController else {
            fatalError()
        }
        portfolioVC.tabBarItem = UITabBarItem(title: "Portfolio", image: #imageLiteral(resourceName: "list_tabbar"), tag: 0)
        portfolioVC.customTransitionCoordinator = TransitionCoordinator(animator: NavigationCustomAnimator())

        let _addTransactionVC = ControllerHelper.instantiateViewController(identifier: "AddTransactionNavigationController")
        guard let addTransactionVC = _addTransactionVC as? AddTransactionNavigationController else {
            fatalError()
        }
        addTransactionVC.tabBarItem = UITabBarItem(title: "Add transaction", image: #imageLiteral(resourceName: "plus_tabbar"), tag: 1)


        let _transactionsVC = ControllerHelper.instantiateViewController(identifier: "TransactionListNavigationController")
        guard let transactionsVC = _transactionsVC as? PortfolioNavigationController else {
            fatalError()
        }
        transactionsVC.tabBarItem = UITabBarItem(title: "Transactions", image: #imageLiteral(resourceName: "pie_tabbar"), tag: 2)
        transactionsVC.customTransitionCoordinator = TransitionCoordinator(animator: NavigationCustomAnimator())


        let tabBarController = CustomTabBarController()
            tabBarController.itemsPresentationsStyle = .onlyImage

        tabBarController.setViewControllers([portfolioVC, addTransactionVC, transactionsVC])

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        CoreDataManager.shared.applicationDocumentsDirectory()
        

        /*
        presenter = PortfolioPresenter(view: nil, portfolioSession: PortfolioSession(coinsAPI: CoinsAPI(context: CoreDataManager.shared.context), fetchedTransactionsController: CoreDataManager.shared.fetchedResultsController(entityName: "Transaction", keyForSort: "date"), portfolioController: PortfolioDataController()))

        presenter.refreshPortfolio()

        let coin = Coin.getManagedObject(by: "btc", in: CoreDataManager.shared.context)!
        Transaction.insert(into: CoreDataManager.shared.context, coin: coin, type: .buy, quantity: 200, date: Date(), price: 112, currencyType: .usd)

        let coin2 = Coin.getManagedObject(by: "eth", in: CoreDataManager.shared.context)!
        Transaction.insert(into: CoreDataManager.shared.context, coin: coin2, type: .buy, quantity: 90, date: Date(), price: 90, currencyType: .usd)

 */
        /*
        coreDataManager = CoreDataManager(modelName: "crypto_graph")
        coreDataManager?.applicationDocumentsDirectory()

        let apiservice = CoinsAPI(context: coreDataManager!.context)

        apiservice.fetchCoinPrice(by: "btc", for: Convert(symbol: "EUR"), success: { price in
            print(price.coinSymbol)
            print(price.price)
        }, failure: {
            print($0)
        }) */

        /*
        apiservice.fetchAllCoins(rankFrom: 3, limits: 3, success: {
            coins in
            coins.forEach { coin in
                print(coin)
                self.coreDataManager!.context.performChanges {
                    let transaction = Transaction.insert(into: self.coreDataManager!.context, coin: coin, type: .buy, quantity: 150.0, date: Date(), price: 326.0, currencyType: .eur)

                    print(transaction)
                }
            }
        }, failure: {
            print($0)
        }) */

        /*
        apiservice.fetchCoin(with: "eth", success: {
            coin in
            print(coin.name)
            print(coin)
        }, failure: {
            error in
            print(error)
        }) */
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

}

