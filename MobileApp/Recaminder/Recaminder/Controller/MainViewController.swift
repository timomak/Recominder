//
//  ViewController.swift
//  Recaminder
//
//  Created by timofey makhlay on 1/31/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

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

    @objc func allowHealthKitButtonPressed() {
        print("button pressed")
        let healthKitTypes: Set = [
            // access step count
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
            
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            print("authrised???")
            print("success: ", success)
        }
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if let e = error {
                print("oops something went wrong during authorisation \(e.localizedDescription)")
            } else {
                print("User has completed the authorization flow")
                self.getHealthData(completion: { (heartRate) in
                    print("heart rate: ", heartRate)
                    self.text.text = "heart rate: " + String(heartRate)
                    })
                
                // Handle all health data
//                self.queryHealthData()
            }
        }
    }
    
    // Check if network manager is working.
    func updateFeed() {
        networkManager.getHealth() { result in
            switch result {
            case let .success(result):
                self.health = result
                print(self.health)
                self.text.text = "hi"
                self.text.text = "Blood Pressure: \(self.health!.bloodPressure)\nHeart Rate: \(self.health!.heartRate)\nDrink Water: \(self.health!.drinkAmount) liters\nWorkout Time: \(self.health!.workoutTime)pm\n"
            case let .failure(error):
                print(error)
            }
        }
    }
    
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
    
    func logIn(_ email: String, _ password: String) {
        networkManager.logInPost(email, password) { result in
            switch result {
            case let .success(result):
                self.text.text = result
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func queryHealthData() {
        print("beginning to get helthkit data")
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: .height)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (_ HKSampleQuery, samplesOrNil, error) in
            
            guard let samples = samplesOrNil as? [HKSample] else {
                print(error, "deosn't work as quantity type.")
                return
            }
            print(samples)
//            self.allSamples = samples
//            print(self.allSamples[0] as? HKQuantityTypeIdentifierHeight)
            
            
            DispatchQueue.main.async {
                // do something when done
                print("everything worked as expected")
            }
        })
        healthStore.execute(sampleQuery)
    }
    
    func getHealthData(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch heart rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
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
    
    func postJson() {
        let data = [
            "email":"test@gmail.com",
            "password":"test12"
                    ]
        let jsonData = try? JSONEncoder().encode(data)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
//        print(jsonString)
        
        // create post request
        let url = URL(string: "https://recominder-api.herokuapp.com/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            
            if let responseJSON = responseJSON as? [String: Any] {
                print("response ",responseJSON)
            }
        }
        
        task.resume()
    }
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

