//
//  JsonInitializable.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 28.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import SwiftyJSON
import CoreData

protocol JSONInitializable: Mappable {

    init?(json: JSON)

}


