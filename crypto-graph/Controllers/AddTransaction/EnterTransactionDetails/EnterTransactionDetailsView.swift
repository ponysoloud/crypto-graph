//
//  EnterTransactionDetailsView.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 03.04.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

protocol EnterTransactionDetailsView: class {

    func showContinuationButton(isVisible: Bool)

    func setPricePlaceholder(_ placeholder: String)

    func moveBack()

}
