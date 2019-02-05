//
//  ViewController.swift
//  Recaminder
//
//  Created by timofey makhlay on 1/31/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

struct Trainer: Encodable {
    let name: String
    let age: String
    let pokemon: [String]
    
    init(json: [String: Any]) {
        self.name = json["name"] as? String ?? "No Name"
        self.age = json["age"] as? String ?? "No Age"
        self.pokemon = json["pokemon"] as? [String] ?? ["No pokemon"]
    }
    
    func makeJson() -> [String:AnyObject] {
        return ["name":name as AnyObject, "age":age as AnyObject, "pokemon":pokemon as AnyObject]
    }
    
    func makeString() -> String {
        var dataString = "{\"name\":\"\(name)\", \"age\":\"\(age)\", \"pokemon\": ["
        for poke in pokemon{
            dataString += "\"" + poke + "\","
        }
        dataString.removeLast()
        dataString += "]}"
        return dataString
    }
}


//struct Dog: Codable {
//    var name: String
//    var owner: String
//}
//
//// Encode
//let dog = Dog(name: "Rex", owner: "Etgar")
//
//let jsonEncoder = JSONEncoder()
//let jsonData = try jsonEncoder.encode(dog)
//let json = String(data: jsonData, encoding: String.Encoding.utf16)
//
//// Decode
//let jsonDecoder = JSONDecoder()
//let dog = try jsonDecoder.decode(Dog.self, from: jsonData)

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
    
    var trainers: [Trainer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(text)
        text.centerOfView(to: view)

        httpRequest(completion: { (trainerArray) in
            self.trainers = trainerArray
            self.text.text = "\(self.trainers[0].name) has \(self.trainers[0].pokemon.count) pokemon"
            self.postJson(trainers: self.trainers)
        })
        
    }
    private func httpRequest(completion : @escaping(([Trainer]) -> ())) {

        //create the url with NSURL
        let url = URL(string: "http://localhost:3000/trainer-api")! //change the url

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: url)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: [String: Any]] {
                    var trainerArray: [Trainer] = []
                    for i in 1...json.count {
                        let trainer = Trainer(json: json[String(i)]!)
                        trainerArray.append(trainer)
                    }
                    DispatchQueue.main.async {
                        completion(trainerArray)
                    }
                }
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        })
        task.resume()
    }
    
    
    func postJson(trainers: [Trainer]) {
        let jsonData = try? JSONEncoder().encode(trainers)
        let jsonString = String(data: jsonData!, encoding: .utf8)!
            print(jsonString)
        
        // create post request
        let url = URL(string: "http://localhost:3000/post")!
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
            
            
            if let responseJSON = responseJSON as? [String: [String: Any]] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
    
}

