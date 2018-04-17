//
//  UIViewController+Extensions.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 17.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit

extension UIViewController
{
    func addHidingKeyboardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
