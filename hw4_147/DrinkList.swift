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
    //@StateObject var drinksData = DrinksData()
    @EnvironmentObject var drinksData: DrinksData
    @AppStorage("target") private var target = 0
    @State private var txtTarget = ""
    @State private var editTarget = false
    @State private var showAlert = false
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                    Text("目標：")
                    TextField("target", text: $txtTarget)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!editTarget)
                        .frame(width: 100, alignment: .leading)
                        .onAppear(){
                            txtTarget = String(target)
                        }
                    Text("ml")
                    Image(systemName: "pencil")
                        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                            if isNumber(txtTarget: txtTarget){
                                target = Int(txtTarget) ?? 3000
                                if(editTarget){
                                    editTarget = false
                                }
                                else{
                                    editTarget = true
                                }
                            }
                            else{
                                showAlert = true
                            }
                            
                        })
                        .alert(isPresented:$showAlert){()-> Alert in
                            return Alert(title: Text("請輸入數字！"))
                                        
                        }
                }

                RingGraph(target: target)
    
                
                Text("剩餘\(target-drinksData.total)ml")
                
                TodayListView()
            }
            
            
        }
    }
    
    func isNumber(txtTarget: String?) -> Bool {
            if Int(txtTarget!) != nil{
                return true
            }
            else{
                return false
            }
        }
    
}

struct DrinkList_Previews: PreviewProvider {
    static var previews: some View {
        DrinkList()
    }
}

struct RingGraph: View {
    var target: Int
    @EnvironmentObject var drinksData: DrinksData
    @State private var waveOffset = Angle(degrees: 0)
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color.gray, lineWidth: 10)
                .opacity(0.2)
                .overlay(
                    Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(caculate(target: target, num: drinksData.total)))
                        .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                        .opacity(0.6)
                        .clipShape(Circle().scale(0.92))
                )
                .overlay(
                    Text("\(Int(caculate(target: target, num: drinksData.total)*100))%")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding(40)
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            self.waveOffset = Angle(degrees: 360)
                        }
                }
            Circle()
                .trim(from: 0, to: CGFloat(caculate(target: target, num: drinksData.total)))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
        }
        .animation(.default)
        .frame(width: 250, height: 250, alignment: .center)
    }
}

struct TodayListView: View {
    @EnvironmentObject var drinksData: DrinksData
    @State private var showEditDrink = false
    var body: some View {
        List{
            Section(header:Text("Today's drinks")){
                ForEach(drinksData.drinks.indices, id : \.self){(index) in
                    if(drinksData.drinks[index].day == getDate()){
                        NavigationLink(destination:DrinkEditor(drinksData: drinksData, editDrinkIndex: index)){
                            DrinkRow(drink: drinksData.drinks[index])
                            
                        }
                    }
                    
                }
                .onMove(perform: move)
                .onDelete{(indexSet) in
                    drinksData.drinks.remove(atOffsets: indexSet)
                    drinksData.caculateTotal(5, selectDate: getDate())
                }
            }
        }
        
        //.navigationBarTitle("沒事多喝水")
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
    func move(from source: IndexSet, to destination: Int) {
        drinksData.drinks.move(fromOffsets: source, toOffset: destination)
    }
}

struct Wave: Shape {

    var offset: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()

        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.015 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

