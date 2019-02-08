//
//  Trainer.swift
//  Recaminder
//
//  Created by timofey makhlay on 2/5/19.
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
