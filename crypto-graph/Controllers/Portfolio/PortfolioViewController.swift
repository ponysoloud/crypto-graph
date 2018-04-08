//
//  MyPortfolioViewController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PortfolioViewController: UIViewController, TabBarChildViewController {

    var presenter: PortfolioPresenter?

    fileprivate var portfolioData: [CoinTransactionsViewData] = []

    @IBOutlet private var portfolioTableView: UITableView!
    @IBOutlet private var titleView: UIView!
    @IBOutlet private var coinNameHintText: UILabel!
    @IBOutlet private var priceHintText: UILabel!
    @IBOutlet private var changeHintText: UILabel!
    @IBOutlet private var profitHintText: UILabel!

    private var headerView: PortfolioHeaderView!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = PortfolioPresenter(view: self, portfolioSession: PortfolioSession(coinsAPI: CoinsAPI(context: CoreDataManager.shared.context), fetchedTransactionsController: CoreDataManager.shared.fetchedResultsController(entityName: "Transaction", keyForSort: "date"), portfolioController: PortfolioDataController()))

        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        portfolioTableView.addSubview(self.refreshControl)

        let nib = UINib(nibName: PortfolioCoinItem.nibName, bundle: nil)
        portfolioTableView.register(nib, forCellReuseIdentifier: PortfolioCoinItem.reuseIdentifier)

        let color = UIColor(hex: 0x626262).withAlphaComponent(0.5)
        coinNameHintText.textColor = color
        priceHintText.textColor = color
        changeHintText.textColor = color
        profitHintText.textColor = color

        setupLayout()

        presenter?.setup()
    }

    private func setupLayout() {
        headerView = PortfolioHeaderView.instanceFromNib()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(headerView, aboveSubview: portfolioTableView)

        headerView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: portfolioTableView.topAnchor, constant: -17.0).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        coinNameHintText.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 7.0).isActive = true

        view.layoutIfNeeded()
    }

    @objc
    private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.refreshPortfolio()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            refreshControl.endRefreshing()
        }
    }
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolioData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = portfolioTableView.dequeueReusableCell(withIdentifier: PortfolioCoinItem.reuseIdentifier, for: indexPath)

        guard let c = cell as? PortfolioCoinItem else {
            fatalError("Reuse identifier doesn't correspond to returned cell")
        }

        let item = portfolioData[indexPath.row]
        c.setup(with: item)

        return c
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = portfolioTableView.cellForRow(at: indexPath) as? PortfolioCoinItem else {
            fatalError()
        }

        cell.animateSelection {
            let _coinScreen = ControllerHelper.instantiateViewController(identifier: "PortfolioCoinScreen")
            guard let coinScreen = _coinScreen as? PortfolioCoinScreen else {
                fatalError()
            }

            coinScreen.portfolioItem = self.portfolioData[indexPath.row]
            self.navigationController?.pushViewController(coinScreen, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let indexes = tableView.indexPathsForVisibleRows, let max = indexes.max() else {
            return
        }

        let direction: UITableViewScrollPosition = max < indexPath ? .bottom : .top

        tableView.isScrollEnabled = false
        tableView.scrollToRow(at: indexPath, at: direction, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            tableView.isScrollEnabled = true
        }
    }
}

extension PortfolioViewController: PortfolioView {

    func updateHeader(with object: TotalTransactionsViewData) {
        headerView.setup(with: object)
    }

    func provide(data: [CoinTransactionsViewData]) {
        portfolioData = data
        portfolioTableView.reloadData()
    }

    func append(_ newObject: CoinTransactionsViewData) {
        portfolioData.append(newObject)

        let indexPath = IndexPath(row: portfolioData.count - 1, section: 0)
        portfolioTableView.insertRows(at: [indexPath], with: .bottom)
    }

    func updateObject(existingAt index: Int, with object: CoinTransactionsViewData) {
        portfolioData[index] = object
        let indexPath = IndexPath(row: index, section: 0)
        portfolioTableView.reloadRows(at: [indexPath], with: .none)
    }

}
