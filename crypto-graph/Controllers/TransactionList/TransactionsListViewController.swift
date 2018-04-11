//
//  TransactionsListViewController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 05.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class TransactionsListViewController: UITableViewController, TabBarChildViewController {

    private var presenter: TransactionsListPresenter?

    private var transactionsData: [TransactionViewData] = []
    private var chartPieces: [Piece] = []

    private var tableViewOperations: [()->Void] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableViewOperations.forEach { $0() }
        tableViewOperations = []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: TransactionsChart.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TransactionsChart.reuseIdentifier)

        let nib2 = UINib(nibName: TransactionItem.nibName, bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: TransactionItem.reuseIdentifier)

        presenter = TransactionsListPresenter(view: self, fetchedTransactionsController: CoreDataManager.shared.fetchedResultsController(entityName: "Transaction", keyForSort: "date"), context: CoreDataManager.shared.context)
        presenter?.setup()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let additional = chartPieces.count > 0 ? 1 : 0
        return transactionsData.count + additional
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsChart.reuseIdentifier, for: indexPath)

            guard let c = cell as? TransactionsChart else {
                fatalError("Reuse identifier doesn't correspond to returned cell")
            }

            let data = chartPieces
            c.setup(with: data)

            return c
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionItem.reuseIdentifier, for: indexPath)

            guard let c = cell as? TransactionItem else {
                fatalError("Reuse identifier doesn't correspond to returned cell")
            }

            let data = transactionsData[indexPath.row - 1]
            c.setup(with: data)
            c.delegate = self            

            return c
        }
    }

}

extension TransactionsListViewController: TransactionItemDelegate {

    func transactionItemDidTapRemove(_ transactionItem: TransactionItem) {
        guard let indexPath = tableView.indexPath(for: transactionItem) else {
            fatalError()
        }

        presenter?.removeTransaction(at: indexPath.row - 1)
    }
}

extension TransactionsListViewController: TransactionsListView {

    func remove(at index: Int) {

        let task = {
            self.tableView.beginUpdates()

            self.transactionsData.remove(at: index)

            let indexPath = IndexPath(row: index + 1, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .fade)

            self.tableView.endUpdates()
        }

        if (self.isViewLoaded && self.view.window != nil){
            task()
        } else {
            tableViewOperations.append(task)
        }
    }

    func insert(data: TransactionViewData, at index: Int) {
        let task = {
            self.tableView.beginUpdates()

            self.transactionsData.insert(data, at: index)

            let indexPath = IndexPath(row: index + 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .bottom)

            self.tableView.endUpdates()
        }

        if (self.isViewLoaded && self.view.window != nil){
            task()
        } else {
            tableViewOperations.append(task)
        }
    }

    func updateChart(with data: [CoinChartData]) {
        let palette: [UIColor] = [
            UIColor(hex: 0x32A2F3),
            UIColor(hex: 0xFCD739),
            UIColor(hex: 0x71769B),
            UIColor(hex: 0xA7DA66)
        ]

        let wasEmpty = chartPieces.isEmpty

        chartPieces = data.enumerated().map {
            let color = palette[$0.offset % palette.count]
            return Piece(color: color, value: CGFloat($0.element.value), name: $0.element.coinName)
        }

        let indexPath = IndexPath(row: 0, section: 0)

        if wasEmpty && chartPieces.isEmpty {
            return
        } else if wasEmpty {
            tableView.insertRows(at: [indexPath], with: .none)
        } else if chartPieces.isEmpty {
            tableView.deleteRows(at: [indexPath], with: .none)
        } else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func provide(chart data: [CoinChartData], transactions: [TransactionViewData]) {
        let palette: [UIColor] = [
            UIColor(hex: 0x32A2F3),
            UIColor(hex: 0xFCD739),
            UIColor(hex: 0x71769B),
            UIColor(hex: 0xA7DA66)
        ]

        chartPieces = data.enumerated().map {
            let color = palette[$0.offset % palette.count]
            return Piece(color: color, value: CGFloat($0.element.value), name: $0.element.coinName)
        }
        transactionsData = transactions
        tableView.reloadData()
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

            label.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        } else {
            guard let label = view.viewWithTag(11) else {
                return
            }

            label.removeFromSuperview()
        }
    }
}
