//
//  DrinkEditor.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI

func getTime(_ selectedTime:Date)->String{
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    let stringTime = timeFormatter.string(from: selectedTime)
    return stringTime
}
func getDate(_ selectedDate:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM"
    let stringDate = dateFormatter.string(from: selectedDate)
    return stringDate
}


struct DrinkEditor: View {
    @Environment(\.presentationMode) var presentationMode
    var drinksData: DrinksData
    var editDrinkIndex: Int?
    
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        return min...max
    }
    @State private var day = getDate(Date())
    @State private var volume = 0
    @State private var time = getTime(Date())
    @State private var showPicker = false
    
    @State private var selectedTime = Date()
    @State private var selectedDate = Date()
 
    var body: some View {
        
        Form{
            HStack{
                TextField("Date", text: $day)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .sheet(isPresented:$showPicker){
                            VStack{
                                DatePicker("", selection: $selectedDate,in:dateClosedRange,displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle())
                                Divider()
                                Button("Done"){
                                    showPicker = false
                                    day = getDate( selectedDate)
                                }
                            }
                        }
                    
                Button("select"){
                    showPicker = true
                }
            }
            HStack{
                TextField("Time", text: $time)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .sheet(isPresented:$showPicker){
                            VStack{
                                DatePicker("", selection: $selectedTime,displayedComponents: .hourAndMinute).datePickerStyle(GraphicalDatePickerStyle())
                                Divider()
                                Button("Done"){
                                    showPicker = false
                                    time = getTime( selectedTime)
                                }
                            }
                        }
                    
                Button("select"){
                    showPicker = true
                }
            }
            Stepper(value: $volume, in: 0...5000, step: 100){
                Text("\(volume) ml")
            }
        }
        .onAppear(perform: {
            if let editDrinkIndex = editDrinkIndex{
                let editDrink = drinksData.drinks[editDrinkIndex]
                day = editDrink.day
                volume = editDrink.volume
                time = editDrink.time
            }
        })
        .navigationBarTitle(editDrinkIndex == nil ? "Add New Drink": "Edit drink")
        .toolbar(content:{
            Button("Save"){
                let drink = Drink(day: day, volume: volume, time:time)
                if let editDrinkIndex = editDrinkIndex{
                    drinksData.drinks[editDrinkIndex] = drink
                    drinksData.caculateTotal(3, selectDate: drink.day)
                    
                }
                else{
                    drinksData.drinks.insert(drink, at: drinksData.drinks.endIndex)
                    if(drink.day==getDate(Date())){
                        drinksData.caculateTotal(4, selectDate: drink.day)

                    }
                }
                presentationMode.wrappedValue.dismiss()
            }
        })
        
    }
}

struct DrinkEditor_Previews: PreviewProvider {
    static var previews: some View {
        DrinkEditor(drinksData: DrinksData())
    }
}
