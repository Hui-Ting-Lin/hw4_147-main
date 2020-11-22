//
//  ContentView.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI

struct ContentView: View {
    
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

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
