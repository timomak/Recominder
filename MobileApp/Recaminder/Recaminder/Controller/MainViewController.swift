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
    var allSamples:[HKSample] = []
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
        
        let bloodPressureSystolicType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!
        
        let bloodPressureDiastolicType:HKQuantityType   = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!
        
        // Reading
        let readingTypes:Set = Set( [heartRateType, bloodPressureSystolicType, bloodPressureDiastolicType] )
        
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
                print("Authorized!")
                
                // Get Heart rate Data
                self.getHeartRateData(completion: { (arrayOfHealthData) in
                    print(arrayOfHealthData!)
                    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    var allHeartRateDataArray: [HeartRate] = []

                    for data in arrayOfHealthData! {
                        let heartModel = HeartRate(rate: data.quantity.doubleValue(for: heartRateUnit), quantityType: "\(data.quantityType)", startDate: df.string(from: data.startDate), endDate: df.string(from: data.endDate), metadata: "\(data.metadata)", uuid: "\(data.uuid)", source: "\(data.source)", device: "\(data.device)")
                        allHeartRateDataArray.append(heartModel)
                    }

                    var allHeartRateData = HealthKitData(heartRateData: allHeartRateDataArray)
                    
                    print("---------\nAll Heart Data\n------------\n",allHeartRateData)
                    
                    
                    let jsonData = try? JSONEncoder().encode(allHeartRateData.heartRateData)
                    let jsonString = String(data: jsonData!, encoding: .utf8)!
                    print("----------------\nData in JSON\n----------------\n",jsonString)
                    
                    // TODO: push data
                    self.networkManager.postHeartData(jsonData!, { (response) in
                        print(response)
                    })
                })
            }
        }
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

    // Keeping this code for future reference.
//    private func httpRequest(completion : @escaping(([Trainer]) -> ())) {
//
//        //create the url with NSURL
//        let url = URL(string: "http://localhost:3000/trainer-api")! //change the url
//
//        //create the session object
//        let session = URLSession.shared
//
//        //now create the URLRequest object using the url object
//        let request = URLRequest(url: url)
//
//        //create dataTask using the session object to send data to the server
//        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//            guard error == nil else {
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                //create json object from data
//                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: [String: Any]] {
//                    var trainerArray: [Trainer] = []
//                    for i in 1...json.count {
//                        let trainer = Trainer(json: json[String(i)]!)
//                        trainerArray.append(trainer)
//                    }
//                    DispatchQueue.main.async {
//                        completion(trainerArray)
//                    }
//                }
//            } catch let jsonError {
//                print(jsonError.localizedDescription)
//            }
//        })
//        task.resume()
//    }
//
//
    
//    func postJson() {
//        let data = [
//            "email":"test@gmail.com",
//            "password":"test12"
//                    ]
//        let jsonData = try? JSONEncoder().encode(data)
//        let jsonString = String(data: jsonData!, encoding: .utf8)!
////        print(jsonString)
//
//        // create post request
//        let url = URL(string: "https://recominder-api.herokuapp.com/api/auth/login")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//
//
//            if let responseJSON = responseJSON as? [String: Any] {
//                print("response ",responseJSON)
//            }
//        }
//
//        task.resume()
//    }
//    func postJson(trainers: [Trainer]) {
//        let jsonData = try? JSONEncoder().encode(trainers)
//        let jsonString = String(data: jsonData!, encoding: .utf8)!
//            print(jsonString)
//
//        // create post request
//        let url = URL(string: "http://localhost:3000/post")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//
//
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
//        }
//
//        task.resume()
//    }
}

