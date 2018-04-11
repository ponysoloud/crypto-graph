//
//  AddTransactionViewController.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class ChooseCoinViewController: UIViewController {

    var presenter: ChooseCoinViewPresenter?

    var transactionDelegate: AddTransactionNavigationControllerDelegate?

    fileprivate var searchResults: [CoinViewData] = []

    @IBOutlet fileprivate var coinTextField: UITextField!
    @IBOutlet fileprivate var searchCoinTableView: UITableView!

    @IBOutlet private var leaveButton: UIButton!

    override func viewDidLoad() {
        coinTextField.delegate = self

        searchCoinTableView.delegate = self
        searchCoinTableView.dataSource = self

        let nib = UINib(nibName: CoinShortItem.nibName, bundle: nil)
        searchCoinTableView.register(nib, forCellReuseIdentifier: CoinShortItem.reuseIdentifier)

        leaveButton.addTarget(self, action: #selector(leaveSession(_:)), for: .touchUpInside)
    }

    @objc
    func leaveSession(_ sender: Any) {
        transactionDelegate?.leave()
    }
}

extension ChooseCoinViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let old = textField.text else {
            return false
        }

        let new = (old as NSString).replacingCharacters(in: range, with: string)

        presenter?.updateSearchingQuery(with: new)
        return true
    }

}

extension ChooseCoinViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinShortItem.reuseIdentifier, for: indexPath)

        guard let c = cell as? CoinShortItem else {
            fatalError("Reuse identifier doesn't correspond to returned cell")
        }

        let item = searchResults[indexPath.row]
        c.setup(with: item)

        return c
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = searchResults[indexPath.row]

        guard let cell = tableView.cellForRow(at: indexPath) as? CoinShortItem else {
            fatalError()
        }

        cell.animateSelection {
            self.presenter?.chooseSearchingResult(viewData)
            self.coinTextField.text = viewData.name
            self.coinTextField.textColor = UIColor.black

            guard let indexPaths = tableView.indexPathsForVisibleRows else {
                return
            }

            let length = indexPaths.count
            var counter: Double = 0
            indexPaths.reversed().enumerated().forEach { i in
                DispatchQueue.main.asyncAfter(deadline: .now() + counter) {
                    self.searchResults.remove(at: i.element.row)
                    tableView.deleteRows(at: [i.element], with: .right)

                    if i.offset == length - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.transactionDelegate?.completeChoosingCoinStep()
                        }
                    }
                }
                counter += 0.08
            }
        }
    }
}

extension ChooseCoinViewController: ChooseCoinView {

    func showLoading(isVisible: Bool) {

    }

    func provide(items: [CoinViewData]) {
        searchResults = items
        searchCoinTableView.reloadData()
    }
}
