//
//  ContentView.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI

struct ContentView: View {
    //@EnvironmentObject var drinksData: DrinksData
    //var drinksData = DrinksData()
    @StateObject var drinksData = DrinksData()
    var body: some View {
        TabView{
            
            DrinkList()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Today")
                }
            ChartView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Chart")
                }
                
        }
        .environmentObject(drinksData)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
