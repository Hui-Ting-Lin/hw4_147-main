//
//  DrinkData.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI

class DrinksData: ObservableObject{
    @AppStorage("drinks") var drinksData: Data?
    @Published var total = 0
    @Published var selectDate = ""
    var dayArray = [""]
    var totals = [0,0,0,0,0,0,0]
    
    func getDate(_ selectedDate:Date)->String{
        //let time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringDate = dateFormatter.string(from: selectedDate)
        return stringDate
    }
    
    func makeDayArray(){
        var newArray = [String]()
        var dayComponent = DateComponents()
        for num in 1..<8{
            dayComponent.day = num-7
            let calendar = Calendar.current
            let nextDay = calendar.date(byAdding: dayComponent, to: Date())!
            newArray.append(getDate(nextDay))
        }
        dayArray = newArray
    }
    func getTotal()->Array<Int>{
        var totalsArray = [0,0,0,0,0,0,0]
        for num in 0..<dayArray.count{
            for drink in drinks {
                if(drink.day==dayArray[num] ){
                    totalsArray[num] = totalsArray[num] + drink.volume
                }
            }
        }
        return totalsArray
    }

    func caculateTotal( _ num: Int, selectDate: String){
        totals = [0,0,0,0,0,0,0]
        for num in 0..<dayArray.count{
            for drink in drinks {
                if(drink.day==dayArray[num] ){
                    totals[num] = totals[num] + drink.volume
                }
            }
        }
        total = totals[6]
    }
    


    
    init(){
        makeDayArray()
        if let drinksData = drinksData{
            let decoder = JSONDecoder()
            selectDate = getDate(Date())
            if let decodedData = try? decoder.decode([Drink].self, from: drinksData){
                drinks = decodedData
                for drink in drinks {
                    if(drink.day == selectDate){
                        total = total + drink.volume
                    }
                }
                caculateTotal(0,selectDate: getDate(Date()))
            }
        }
        
        
    }
    @Published var drinks = [Drink](){
        didSet{
            let encoder = JSONEncoder()
            do{
                let data = try encoder.encode(drinks)
                drinksData = data
                
            }catch{
                
            }
        }
    }
}

struct DrinksData_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
