//
//  HeartRate.swift
//  Recaminder
//
//  Created by timofey makhlay on 2/7/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit


struct HealthKitData: Encodable {
    var heartRateData: [HeartRate]
    // TODO: Finish other models
    //    var bloodPressureData:
    
    init(heartRateData:[HeartRate]) {
        self.heartRateData = heartRateData
    }
}

struct HeartRate: Encodable {
    var rate: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(rate: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
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

struct HeightData: Encodable {
    var height: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(height: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.height = height
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

