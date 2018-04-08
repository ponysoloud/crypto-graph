//
//  ConcurrentBlocks.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 29.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation

class ConcurrentBlocksArray<Result> {

    let count: Int
    let final: ([Result]) -> Void

    var results: [Result] = []
    var counter: Int = 0

    init(count: Int, end completion: @escaping ([Result]) -> Void) {
        self.count = count
        self.final = completion
    }

    let internalQueue = DispatchQueue(label: "serialQueue")
    let semaphore = DispatchSemaphore(value: 1)

    func add(result: Result) {
        internalQueue.async {
            self.semaphore.wait()

            guard self.counter < self.count else {
                self.semaphore.signal()
                return
            }

            self.results.append(result)
            self.counter += 1

            if self.counter == self.count {
                self.final(self.results)
            }

            self.semaphore.signal()
        }
    }


}
