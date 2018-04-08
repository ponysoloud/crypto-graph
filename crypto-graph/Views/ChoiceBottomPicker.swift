//
//  ChoiceBottomPicker.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class ChoiceBottomPicker {

    let picker: UIAlertController

    init(title: String, choices: [String], chooseAction: @escaping (String) -> Void) {
        picker = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)

        choices.forEach { choice in
            let action = UIAlertAction(title: choice, style: .default, handler: { _ in
                chooseAction(choice)
            })
            picker.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (result : UIAlertAction) -> Void in
        }
        picker.addAction(cancelAction)
    }

    func present(in viewController: UIViewController) {
        viewController.present(picker, animated: true, completion: nil)
    }

}
