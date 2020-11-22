//
//  CalendarView.swift
//  hw4_147
//
//  Created by User20 on 2020/11/22.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    var body: some View {
        VStack{
            DatePicker("", selection: $selectedDate,displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
