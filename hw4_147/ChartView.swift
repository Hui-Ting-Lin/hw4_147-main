//
//  ChartView.swift
//  hw4_147
//
//  Created by User20 on 2020/11/17.
//

import SwiftUI

func getDate(selectedDate:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM"
    let stringDate = dateFormatter.string(from: selectedDate)
    return stringDate
}


struct ChartView: View {
    @StateObject var drinksData = DrinksData()
    @State private var today = Date()
   
    var body: some View {
        VStack{
            MyChartView(dayArray: drinksData.dayArray, totalArray:drinksData.getTotal())
            ForEach(drinksData.drinks.indices, id : \.self){(index) in
                DrinkRow(drink: drinksData.drinks[index])
                
            }
        }
        
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            print("99999")
            drinksData.caculateTotal(543, selectDate: getDate(Date()))
        })
    }
}



struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

struct BarView: View {
    var percentage: CGFloat
    var txt: String
    var color: Color

    var body: some View {
        VStack{
            Text("\(Int(percentage*100))%")
                .padding(.bottom, 2)
                .font(.system(size: 11))
                .frame(width:30)
            ZStack(alignment: .bottom){
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 30, height: 225)
                    .foregroundColor(Color(#colorLiteral(red: 0.721724689, green: 0.879203558, blue: 0.8636844754, alpha: 1)))

                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 30, height: (225*percentage))
                    .foregroundColor(color)
                
            }
            Text(txt)
                .padding(.top, 2)
                .font(.system(size: 12))
                .frame(width:35)
            
            
        }
    }
}

struct MyChartView: View {
    var dayArray: Array<String>
    var totalArray: Array<Int>
    
    var body: some View {
        
        VStack{
            Text("Weekly Review")
            Text("\(dayArray[0]) - \(dayArray[6])")
            HStack{
                ForEach(0..<dayArray.count){(index) in
                    if(dayArray[index]==getDate(Date())){
                        BarView(percentage: CGFloat(totalArray[index])/3000 <= 1 ? CGFloat(totalArray[index])/3000 : 1 , txt: "\(dayArray[index])", color:  Color(#colorLiteral(red: 0.949680388, green: 0.7101557851, blue: 0.7510160804, alpha: 1)))
                    }//today: special color
                    else{
                        BarView(percentage: CGFloat(totalArray[index])/3000 <= 1 ? CGFloat(totalArray[index])/3000 : 1 , txt: "\(dayArray[index])", color:  Color(#colorLiteral(red: 0.9651429253, green: 0.9673617344, blue: 0.8636844754, alpha: 1)))
                    }
                    
                }
            }
            .padding(.top, 24)
        }

    }
}
