//
//  ViewController.swift
//  Recaminder
//
//  Created by timofey makhlay on 1/31/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

struct Trainer {
    let name: String
    let age: String
    let pokemon: [String]
    
    init(json: [String: Any]) {
        self.name = json["name"] as? String ?? "No Name"
        self.age = json["age"] as? String ?? "No Age"
        self.pokemon = json["pokemon"] as? [String] ?? ["No pokemon"]
    }
}

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
        
//        let jsonString = "http://localhost:3000/"
//
//        guard let url = URL(string: jsonString) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            // Check error
//
//            // Do stuff
//            guard let data = data else {return}
//
//            let dataAsString = String(data: data, encoding: .utf8)
//            print(dataAsString)
//        }.resume()

        httpRequest(completion: { (trainerArray) in
            self.trainers = trainerArray
            self.text.text = "\(self.trainers[0].name) has \(self.trainers[0].pokemon.count) pokemon"
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
    
}

