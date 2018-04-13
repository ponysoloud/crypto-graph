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

    @IBOutlet private var nameWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var priceRangeConstraint: NSLayoutConstraint!

    private var headerView: PortfolioHeaderView!

    private var swipeGestureBlocking: Bool!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray

        return refreshControl
    }()

    private var tableViewOperations: [()->Void] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableViewOperations.forEach { $0() }
        tableViewOperations = []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = PortfolioPresenter(view: self, portfolioSession: PortfolioSession(coinsAPI: CoinsAPI(context: CoreDataManager.shared.context), fetchedTransactionsController: CoreDataManager.shared.fetchedResultsController(entityName: "Transaction", keyForSort: "date"), portfolioController: PortfolioDataController()))

        portfolioTableView.delegate = self
        portfolioTableView.dataSource = self
        portfolioTableView.addSubview(self.refreshControl)



        /*
        swipeGestureBlocking = false

        var swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpHandler(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.portfolioTableView.addGestureRecognizer(swipeUp)

        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownHandler(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.portfolioTableView.addGestureRecognizer(swipeDown)
 */

        portfolioTableView.rowHeight = UITableViewAutomaticDimension
        portfolioTableView.estimatedRowHeight = PortfolioCoinItem.height

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

        switch UIDevice.current.screenType {
        case .extraSmall, .small, .unknown:
            nameWidthConstraint.constant = 50.0
        case .medium:
            nameWidthConstraint.constant = 68.0
            priceRangeConstraint.constant = 58.0
        case .plus, .extra:
            nameWidthConstraint.constant = 70.0
            priceRangeConstraint.constant = 73.0
        }

        view.layoutIfNeeded()
    }

    @objc
    private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.refreshPortfolio()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            refreshControl.endRefreshing()
        }
    }

    private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("IN NUMBER \(portfolioData.count)")
        return portfolioData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PortfolioCoinItem.height
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

        tableView.isUserInteractionEnabled = false
        tableView.scrollToRow(at: indexPath, at: direction, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            tableView.isUserInteractionEnabled = true
        }
    }

    /*
    @objc
    func swipeUpHandler(_ sender: Any) {
        guard !swipeGestureBlocking, let indexes = portfolioTableView.indexPathsForVisibleRows, let max = indexes.max() else {
            return
        }

        let count = portfolioTableView.numberOfRows(inSection: 0)

        if max.row < count - 1 {
            swipeGestureBlocking = true
            portfolioTableView.scrollToRow(at: IndexPath(row: max.row + 1, section: 0), at: .bottom, animated: true)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.swipeGestureBlocking = false
        }
    }

    @objc
    func swipeDownHandler(_ sender: Any) {
        guard !swipeGestureBlocking, let indexes = portfolioTableView.indexPathsForVisibleRows, let min = indexes.min() else {
            return
        }

        if min.row > 0 {
            swipeGestureBlocking = true
            portfolioTableView.scrollToRow(at: IndexPath(row: min.row - 1, section: 0), at: .top, animated: true)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.swipeGestureBlocking = false
        }
    } */
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

        let task = {
            self.portfolioTableView.beginUpdates()

            self.portfolioData.append(newObject)

            let indexPath = IndexPath(row: self.portfolioData.count - 1, section: 0)
            self.portfolioTableView.insertRows(at: [indexPath], with: .bottom)

            self.portfolioTableView.endUpdates()
        }

        if (self.isViewLoaded && self.view.window != nil){
            task()
        } else {
            tableViewOperations.append(task)
        }
    }

    func updateObject(existingAt index: Int, with object: CoinTransactionsViewData) {
        let task = {
            self.portfolioTableView.beginUpdates()

            self.portfolioData[index] = object

            let indexPath = IndexPath(row: index, section: 0)
            self.portfolioTableView.reloadRows(at: [indexPath], with: .none)

            self.portfolioTableView.endUpdates()
        }

        if (self.isViewLoaded && self.view.window != nil){
            task()
        } else {
            tableViewOperations.append(task)
        }
    }

    func remove(at index: Int) {

        let task = {
            self.portfolioTableView.beginUpdates()

            self.portfolioData.remove(at: index)

            let indexPath = IndexPath(row: index, section: 0)
            self.portfolioTableView.deleteRows(at: [indexPath], with: .fade)

            self.portfolioTableView.endUpdates()
        }

        if (self.isViewLoaded && self.view.window != nil){
            task()
        } else {
            tableViewOperations.append(task)
        }
    }

    func show(placeholder message: String, isVisible: Bool) {
        if isVisible {
            if let _ = view.viewWithTag(11) {
                return
            }

            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
            label.text = message
            label.textColor = UIColor(hex: 0xD5D5D5)
            label.tag = 11

            label.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(label)

            label.centerXAnchor.constraint(equalTo: portfolioTableView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: portfolioTableView.centerYAnchor).isActive = true
        } else {
            guard let label = view.viewWithTag(11) else {
                return
            }

            label.removeFromSuperview()
        }
    }
}
