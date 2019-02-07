//
//  HeartRate.swift
//  Recaminder
//
//  Created by timofey makhlay on 2/7/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

struct HeartRate: Encodable {
    var rate: Double
    var quantityType: String
    var startDate: Date
    var endDate: Date
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(rate: Double, quantityType: String, startDate: Date, endDate: Date, metadata: String, uuid: String, source: String, device: String) {
        self.rate = rate
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct HeartRateData: Encodable {
    var data: [HeartRate]
    
    init(data:[HeartRate]) {
        self.data = data
    }
}


