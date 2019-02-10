//
//  ViewController.swift
//  Recaminder
//
//  Created by timofey makhlay on 1/31/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

// TODO: Clean up commented out (useless) code
// TODO: Create a Heart Rate and Blood Pressure structs
// TODO: Optimize Authorization
// TODO: Split the functions into different views
// TODO: Create front end
// TODO: Remove redundunt actions like logging in every session
// TODO: Perform A LOT of testing


import UIKit
import HealthKit

class MainViewController: UIViewController {

    let text: UITextView = {
        var title = UITextView()
        title.text = "Database"
        title.font = UIFont(name: "AvenirNext-Bold", size: 30)
        title.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    private let allowHealthKitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Allow HealthKit Data Access", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
//        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(allowHealthKitButtonPressed), for: .touchUpInside)
        return button
    }()
    
//    var trainers: [Trainer] = []
    var health: Health?
    var networkManager = NetworkManager()
    let healthStore = HKHealthStore()
    
    var heartRateArrayDataGlobal: [HeartRate] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(text)
        text.centerOfView(to: view)
        
        view.addSubview(allowHealthKitButton)
        allowHealthKitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        
        // Get from Database
//        updateFeed()
        
        // CURRENT VERSION OF LOG IN
//        postJson()
        
        // TESTING SIGN UP (working)
//        signUp("test2@gmail.com", "test2")
        
        // Testing LOG IN (working [will return "couldNotParse" but it's working.])
        logIn("test@gmail.com", "test123")
        
        // OLD TEST OF GET REQUEST
//        httpRequest(completion: { (trainerArray) in
//            self.trainers = trainerArray
//            self.text.text = "\(self.trainers[0].name) has \(self.trainers[0].pokemon.count) pokemon"
//            self.postJson(trainers: self.trainers)
//        })
        
    }
    
    func requestAuthorization()
    {
        /* Function to request Authorization to access user's HealthKit Data. If Authorized, it gets the data and uses struct to hold them. As a struct, it sends it to the database*/
        
        // Variables I'm trying to get from HealthKit
        let heartRateType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let heightType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        
        let bloodPressureSystolicType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!
        
        let bloodPressureDiastolicType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!
        
        let bodyMassType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        let bodyTemperatureType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!
        
        let activeEnergyBurnedType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        
        let leanBodyMassType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.leanBodyMass)!
        
        let respiratoryRateType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!
        
        let restingHeartRateType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!
        
        let stepCountType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        // Reading
        let readingTypes:Set = Set([heartRateType, bloodPressureSystolicType, bloodPressureDiastolicType, bodyMassType, bodyTemperatureType, activeEnergyBurnedType, heightType, leanBodyMassType, respiratoryRateType, restingHeartRateType, stepCountType])
        
        // Writing (not writing any data)
        //let writingTypes:Set = Set( [heartRateType, bloodPressureSystolicType, bloodPressureDiastolicType] )
        
        // Request Authorization for data.
        healthStore.requestAuthorization(toShare: nil, read: readingTypes) { (success, error) -> Void in
            
            if error != nil
            {
                print("error: \(error?.localizedDescription ?? "Error while requesting HealthKit data")")
            }
            else if success
            {
                /* I'm sorry if you're seeing this. Please don't show it to any of the teachers at Make School. I would get kicked out */
                
                print("Authorized!")
                
                // Get Heart rate Data
                self.getHeartRateData(completion: { (arrayOfHealthData) in
                    // Going to be converting all dates to this value
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    // Arrays for all data types
                    var heightArrayData: [HeightData] = []
                    var heartRateArrayData: [HeartRate] = []
                    var bloodPressureSystolicArrayData: [BloodPressureSystolicData] = []
                    var bloodPressureDiastolicArrayData: [BloodPressureDiastolicData] = []
                    var bodyMassArrayData: [BodyMassData] = []
                    var bodyTemperatureArrayData: [BodyTemperatureData] = []
                    var activeEnergyBurnedArrayData: [ActiveEnergyBurnedData] = []
                    var leanBodyMassArrayData: [LeanBodyMassData] = []
                    var respiratoryRateArrayData: [RespiratoryRateData] = []
                    var restingHeartRateArrayData: [RestingHeartRateData] = []
                    var stepCountArrayData: [StepCountData] = []
                    
                    let countPerMinute:HKUnit = HKUnit(from: "count/min")
                
                    for data in arrayOfHealthData! {
                        let heartModel = HeartRate(rate: data.quantity.doubleValue(for: countPerMinute), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                        heartRateArrayData.append(heartModel)
                    }
                    
                    // Get Height Data
                    self.getHeightData(completion: { (heightData) in
                        // TODO: HEIGHT MODEL
                        let heightUnit:HKUnit = HKUnit(from: "ft")
                        for data in heightData! {
                            let heightModel = HeightData(height: data.quantity.doubleValue(for: heightUnit), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                            heightArrayData.append(heightModel)
                        }
                        self.getBloodPressureSystolicData(completion: { (bloodPressureSysRawData) in
                            let bloodPressureSysUnit:HKUnit = HKUnit(from: "mmHg")
                            
                            for data in bloodPressureSysRawData! {
                                let bloodPressureSysModel = BloodPressureSystolicData(value: data.quantity.doubleValue(for: bloodPressureSysUnit), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                bloodPressureSystolicArrayData.append(bloodPressureSysModel)
                            }
                            self.getBloodPressureDiastolicData(completion: { (bloodPressureDiastolicRawData) in
                                
                                for data in bloodPressureDiastolicRawData! {
                                    let bloodPressureDiastolicModel = BloodPressureDiastolicData(value: data.quantity.doubleValue(for: bloodPressureSysUnit), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                    bloodPressureDiastolicArrayData.append(bloodPressureDiastolicModel)
                                }
                                
                                self.getBodyMassData(completion: { (bodyMassRawData) in
                                    let pounds:HKUnit = HKUnit(from: "lb")
                                    
                                    for data in bodyMassRawData! {
                                        let bodyMassModel = BodyMassData(value: data.quantity.doubleValue(for: pounds), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                        bodyMassArrayData.append(bodyMassModel)
                                    }
                                    self.getBodyTemperatureData(completion: { (bodyTemperatureRawData) in
                                        let fahrenheit:HKUnit = HKUnit(from: "degF")
                                        
                                        for data in bodyTemperatureRawData! {
                                            let bodyTemperatureModel = BodyTemperatureData(value: data.quantity.doubleValue(for: fahrenheit), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                            bodyTemperatureArrayData.append(bodyTemperatureModel)
                                        }
                                        self.getActiveEnergyBurnedData(completion: { (activeEnergyBurnedRawData) in
                                            let calorie:HKUnit = HKUnit(from: "kcal")
                                            
                                            for data in activeEnergyBurnedRawData! {
                                                let activeEnergyBurnedModel = ActiveEnergyBurnedData(value: data.quantity.doubleValue(for: calorie), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                                activeEnergyBurnedArrayData.append(activeEnergyBurnedModel)
                                            }
                                            
                                            self.getLeanBodyMassData(completion: { (leanBodyMassRawData) in
                                                
                                                for data in leanBodyMassRawData! {
                                                    let leanBodyMassModel = LeanBodyMassData(value: data.quantity.doubleValue(for: pounds), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                                    leanBodyMassArrayData.append(leanBodyMassModel)
                                                }
                                                
                                                self.getRespiratoryRateData(completion: { (respiratoryRateRawData) in
                                                    
                                                    for data in respiratoryRateRawData! {
                                                        let respiratoryRateModel = RespiratoryRateData(value: data.quantity.doubleValue(for: countPerMinute), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                                        respiratoryRateArrayData.append(respiratoryRateModel)
                                                    }
                                                    self.getRestingHeartRateData(completion: { (restingHeartRateRawData) in
                                                        for data in restingHeartRateRawData! {
                                                            let restingHeartRateModel = RestingHeartRateData(value: data.quantity.doubleValue(for: countPerMinute), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                                            restingHeartRateArrayData.append(restingHeartRateModel)
                                                        }
                                                        self.getStepCountData(completion: { (stepCountRawData) in
                                                            let count:HKUnit = HKUnit(from: "count")
                                                            
                                                            for data in stepCountRawData! {
                                                                let stepCountModel = StepCountData(value: data.quantity.doubleValue(for: count), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                                                                stepCountArrayData.append(stepCountModel)
                                                            }
                                                            // Code for the most inner nested to export all the data as JSON
                                                            var healthKitData = HealthKitData(heartRateData: heartRateArrayData, heightData: heightArrayData, bloodPressureSystolicData: bloodPressureSystolicArrayData, bloodPressureDiastolicData: bloodPressureDiastolicArrayData, bodyMassData: bodyMassArrayData, bodyTemperatureData: bodyTemperatureArrayData, activeEnergyBurnedData: activeEnergyBurnedArrayData, leanBodyMassData: leanBodyMassArrayData, respiratoryRateData: respiratoryRateArrayData, restingHeartRateData: restingHeartRateArrayData, stepCountData: stepCountArrayData)
                                                            
                                                            let jsonData = try? JSONEncoder().encode(healthKitData)
                                                            let jsonString = String(data: jsonData!, encoding: .utf8)!
                                                            print("----------------\nData in JSON\n----------------\n",jsonString)
                                                            
                                                            // TODO: push data
                                                            self.networkManager.postHeartData(jsonData!, { (response) in
                                                                print(response)
                                                                
                                                                
                                                            }) // End of pushing data to server

                                                            
                                                        }) // End of Step Count
                                                        
                                                    }) // End of Resting heart Rate
                                                    
                                                }) // End of Respiratory Rate Data
                                                
                                            }) // End of lean body mass data
                                            
                                        }) // End of active energy burned data
                                        
                                    }) // End of Body Temperature data
                                    
                                }) // End of Body Mass Data

                            }) // End of blood pressure diastolic data
            
                        }) // End of Blood Pressure Sys Data

                    }) // End of Height data
                    
                }) // End of HeartRate data
                
            } // End of Request auth
            
        } // End of Else statement
        
    }

    @objc func allowHealthKitButtonPressed() {
        print("button pressed")
        requestAuthorization()
    }
    
    // TODO: Get Function to pull processed data from database
//    func updateFeed() {
//        networkManager.getHealth() { result in
//            switch result {
//            case let .success(result):
//                self.health = result
//                print(self.health)
//                self.text.text = "hi"
//                self.text.text = "Blood Pressure: \(self.health!.bloodPressure)\nHeart Rate: \(self.health!.heartRate)\nDrink Water: \(self.health!.drinkAmount) liters\nWorkout Time: \(self.health!.workoutTime)pm\n"
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
    
    // SignUp Netowking method. Will POST email and password to sign up.
    func signUp(_ email: String, _ password: String) {
        networkManager.signUpPost(email, password) { result in
            switch result {
                case let .success(result):
                    self.text.text = result
            case let .failure(error):
                print(error)
            case .failedSigning(_): break
                // Test code
            }
        }
    }
    
    // Login Networking Method. Will POST email and password to Login.
    func logIn(_ email: String, _ password: String) {
        networkManager.logInPost(email, password) { result in
            switch result {
            case let .success(result):
                print(result)
                self.text.text = result
            case let .failure(error):
                print(error)
            case .failedSigning(_): break
                // test code
            }
        }
    }
    
    func getHeartRateData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Date to end location
        //let now = Date()
        
        // Date to start location
        //let startOfDay = Calendar.current.startOfDay(for: now)
        
        //Predicate (won't be needing it to get all data. Useful when looking for specific data)
        //let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: .strictEndDate)
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .heartRate)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getHeightData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .height)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getBloodPressureSystolicData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getBloodPressureDiastolicData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getBodyMassData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .bodyMass)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getBodyTemperatureData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .bodyTemperature)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getActiveEnergyBurnedData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getLeanBodyMassData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .leanBodyMass)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getRespiratoryRateData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .respiratoryRate)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getRestingHeartRateData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .restingHeartRate)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
    
    func getStepCountData(completion: @escaping (_ heartRate: [HKQuantitySample]?) -> Void) {
        /* Once Authorized to get data, this function will locate and pull the data. */
        
        // Tell what type of data it's looking for.
        let dataQuery = HKSampleQuery.init(sampleType: HKObjectType.quantityType(forIdentifier: .stepCount)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (sampleQuery, samplesOrNil, error) in
            
            // Check if data is of right type
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            
            DispatchQueue.main.async {
                // Return Heart Rate data when done.
                completion(samples)
            }
        })
        // Runs the data query to get data
        healthStore.execute(dataQuery)
    }
}

