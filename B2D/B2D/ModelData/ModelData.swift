//
//  ModeleData.swift
//  B2D
//
//  Created by  b2d on 1/15/24.
//

import Foundation

struct ResData: Decodable{
    var egg: [EggImg]
    var monster: [Dragon3D]
}

@Observable
class ModelData{
    
    var eggs: [EggImg]
    var dragons: [Dragon3D]
    
    init(){
        let resData: ResData = load("b2dData.json")
        self.eggs = resData.egg
        self.dragons = resData.monster
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


