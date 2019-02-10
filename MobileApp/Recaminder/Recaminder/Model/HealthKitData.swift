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
    var heightData: [HeightData]
    var bloodPressureSystolicData: [BloodPressureSystolicData]
    var bloodPressureDiastolicData: [BloodPressureDiastolicData]
    var bodyMassData: [BodyMassData]
    var bodyTemperatureData: [BodyTemperatureData]
    var activeEnergyBurnedData: [ActiveEnergyBurnedData]
    var leanBodyMassData: [LeanBodyMassData]
    var respiratoryRateData: [RespiratoryRateData]
    var restingHeartRateData: [RestingHeartRateData]
    var stepCountData: [StepCountData]
    
    init(heartRateData:[HeartRate], heightData: [HeightData], bloodPressureSystolicData: [BloodPressureSystolicData], bloodPressureDiastolicData: [BloodPressureDiastolicData], bodyMassData: [BodyMassData], bodyTemperatureData: [BodyTemperatureData], activeEnergyBurnedData: [ActiveEnergyBurnedData], leanBodyMassData: [LeanBodyMassData], respiratoryRateData: [RespiratoryRateData], restingHeartRateData: [RestingHeartRateData], stepCountData: [StepCountData]) {
        
        self.heartRateData = heartRateData
        self.heightData = heightData
        self.bloodPressureSystolicData = bloodPressureSystolicData
        self.bloodPressureDiastolicData = bloodPressureDiastolicData
        self.bodyMassData = bodyMassData
        self.bodyTemperatureData = bodyTemperatureData
        self.activeEnergyBurnedData = activeEnergyBurnedData
        self.leanBodyMassData = leanBodyMassData
        self.respiratoryRateData = respiratoryRateData
        self.restingHeartRateData = restingHeartRateData
        self.stepCountData = stepCountData
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

struct BloodPressureSystolicData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct BloodPressureDiastolicData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct BodyMassData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct BodyTemperatureData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct ActiveEnergyBurnedData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct LeanBodyMassData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct RespiratoryRateData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct RestingHeartRateData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}

struct StepCountData: Encodable {
    var value: Double
    var quantityType: String
    var startDate: String
    var endDate: String
    var metadata: String
    var uuid: String
    var source: String
    var device: String
    
    init(value: Double, quantityType: String, startDate: String, endDate: String, metadata: String, uuid: String, source: String, device: String) {
        self.value = value
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.metadata = metadata
        self.uuid = uuid
        self.source = source
        self.device = device
    }
}
