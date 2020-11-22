//
//  DrinkRow.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI

struct DrinkRow: View {
    var drink: Drink
    var body: some View {
        HStack{
            Text(drink.time)
            Text("\(drink.volume)ml")
        }
    }
}

struct DrinkRow_Previews: PreviewProvider {
    static var previews: some View {
        DrinkRow(drink: Drink(day: "11/17", volume: 200, time: "13:00"))
    }
}
