//
//  dice.swift
//  RollDice
//
//  Created by aplle on 4/17/23.
//

import Foundation
struct Dice:Identifiable,Codable,Equatable{
    var id = UUID()
    let number:Int
}
