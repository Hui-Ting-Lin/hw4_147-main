//
//  DrinkList.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI
func caculate(target: Int, num: Int) -> Double{
    return Double(num)/Double(target)
}
func getDate()->String{
    let time = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM"
    let stringDate = dateFormatter.string(from: time)
    return stringDate
}

/*func makeCommand(amount: Int)->String{
    var command = ""
    if(amount<1000){
       command = "喝太少了!!"
    }
    else if(amount<2000){
        command = "多喝一點!"
    }
    else if(amount>3000){
        command = "喝太多啦!!"
    }
    else{
        command = "你超棒"
    }
    return command
}*/
struct DrinkList: View {
    @StateObject var drinksData = DrinksData()
    @State private var showEditDrink = false
    let target = 3000
    var body: some View {
        
        NavigationView{
            VStack{
                ZStack{
                    Circle()
                        .stroke(Color.gray, lineWidth: 10)
                        .opacity(0.2)
                        .overlay(
                            Text("\(Int(caculate(target: target, num: drinksData.total)*100))%")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                                .padding(40)
                        )
                    Circle()
                        .trim(from: 0, to: CGFloat(caculate(target: target, num: drinksData.total)))
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                }
                .frame(width: 250, height: 250, alignment: .center)
                Text("剩餘\(target-drinksData.total)ml")
                List{
                    Section(header:Text("Today's drinks")){
                        ForEach(drinksData.drinks.indices, id : \.self){(index) in
                            if(drinksData.drinks[index].day == getDate()){
                                NavigationLink(destination:DrinkEditor(drinksData: drinksData, editDrinkIndex: index)){
                                DrinkRow(drink: drinksData.drinks[index])
                                    
                                }
                            }
                            
                        }
                        .onDelete{(indexSet) in
                            drinksData.drinks.remove(atOffsets: indexSet)
                            drinksData.caculateTotal(5, selectDate: getDate())
                        }
                    }
                }
                
                .navigationBarTitle("沒事多喝水")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showEditDrink = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                            })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                })
                .sheet(isPresented:$showEditDrink){
                    NavigationView{
                        DrinkEditor(drinksData: drinksData)
                    }
                }
            }
        }
    }
}

struct DrinkList_Previews: PreviewProvider {
    static var previews: some View {
        DrinkList()
    }
}
