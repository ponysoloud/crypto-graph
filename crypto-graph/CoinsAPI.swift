//
//  CoinsAPI.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 27.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

final class CoinsAPI {

    private let apiEndpoint: APIEndpoint

    init(with apiEndpoint: APIEndpoint) {
        self.apiEndpoint = apiEndpoint
    }

    func fetchAllCoins(starts: Int = 0, limits: Int = 100, success: @escaping ([Cryptocurrency]) -> Void, failure: @escaping (RequestError) -> Void) {
        let parameters = ["start": "\(starts)", "limit": "\(limits)"]
        apiEndpoint.request(action: .ticker, parameters: parameters, success: success, failure: failure)
    }

    func fetchCoin(with id: String, success: @escaping ([Cryptocurrency]) -> Void, failure: @escaping (RequestError) -> Void) {
        apiEndpoint.request(action: .tickerWith(id: id), success: success, failure: failure)
    }

    func cancellAllTasks() {
        apiEndpoint.cancellAllTasks()
    }



}
