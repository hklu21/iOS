//
//  Animal.swift
//  ZOO
//
//  Created by 卢恒宽 on 1/19/22.
//

import Foundation
import UIKit

class Animal : CustomStringConvertible {
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    let soundPath: String
    var description: String {
        return "Animal: name = \(name), species = \(species), age = \(age)"
    }
    init(name: String, species: String, age: Int, image: UIImage, soundPath: String) {
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
    }
    
}
