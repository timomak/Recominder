//
//  Health.swift
//  Recaminder
//
//  Created by timofey makhlay on 2/5/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

// This is going to be broken down into 4 models.
// For the Skateboard version, I'm going to be keeping it at only 1 with their averages.

struct Health {
    var bloodPressure: Double
    var heartRate: Double
    var drinkAmount: Double
    var workoutTime: Double
}

extension Health: Decodable {
    enum HealthKeys: String, CodingKey {
        case bloodPressure = "blood_pressure"
        case heartRate = "heart_rate"
        case drinkAmount = "drink_amount"
        case workoutTime = "workout_time"
    }
    
    init(from decoder: Decoder) throws {
        let healthContains = try decoder.container(keyedBy: HealthKeys.self)
        bloodPressure = try healthContains.decode(Double.self, forKey: .bloodPressure)
        heartRate = try healthContains.decode(Double.self, forKey: .heartRate)
        drinkAmount = try healthContains.decode(Double.self, forKey: .drinkAmount)
        workoutTime = try healthContains.decode(Double.self, forKey: .workoutTime)
    }
}
