//
//  Drink.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import Foundation
struct Drink: Identifiable, Codable{
    var id = UUID()
    var day: String
    var volume: Int
    var time: String
}
