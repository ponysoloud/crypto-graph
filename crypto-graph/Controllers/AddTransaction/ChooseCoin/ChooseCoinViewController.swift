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

    private var leaveButton: UIBarButtonItem!

    override func viewDidLoad() {
        coinTextField.delegate = self

        searchCoinTableView.delegate = self
        searchCoinTableView.dataSource = self

        let nib = UINib(nibName: CoinShortItem.nibName, bundle: nil)
        searchCoinTableView.register(nib, forCellReuseIdentifier: CoinShortItem.reuseIdentifier)

        leaveButton = UIBarButtonItem(image: #imageLiteral(resourceName: "exit_icon"), style: .plain, target: self, action: #selector(tapLeaveSession(_:)))
        leaveButton.tintColor = UIColor.black.withAlphaComponent(0.1)

        navigationItem.rightBarButtonItem = leaveButton
    }

    @objc
    func tapLeaveSession(_ sender: Any) {
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
        presenter?.chooseSearchingResult(searchResults[indexPath.row])
        transactionDelegate?.completeChoosingCoinStep()
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
