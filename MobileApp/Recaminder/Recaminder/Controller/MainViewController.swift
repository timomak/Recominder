//
//  ViewController.swift
//  Recaminder
//
//  Created by timofey makhlay on 1/31/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

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
    
//    var trainers: [Trainer] = []
    var health: Health?
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(text)
        text.centerOfView(to: view)
        updateFeed()
//        httpRequest(completion: { (trainerArray) in
//            self.trainers = trainerArray
//            self.text.text = "\(self.trainers[0].name) has \(self.trainers[0].pokemon.count) pokemon"
//            self.postJson(trainers: self.trainers)
//        })
        
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
//            if let responseJSON = responseJSON as? [String: [String: Any]] {
//                print(responseJSON)
//            }
//        }
//
//        task.resume()
//    }
//
}

