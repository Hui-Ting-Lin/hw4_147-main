//
//  MyDatePicker.swift
//  hw4_147
//
//  Created by User20 on 2020/11/22.
//

import SwiftUI

struct MyDatePicker: UIViewRepresentable {

    @Binding var selection: Date
    let minuteInterval: Int
    let displayedComponents: DatePickerComponents

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MyDatePicker>) -> UIDatePicker {
        let picker = UIDatePicker()
        // listen to changes coming from the date picker, and use them to update the state variable
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }

    func updateUIView(_ picker: UIDatePicker, context: UIViewRepresentableContext<MyDatePicker>) {
        picker.minuteInterval = minuteInterval
        picker.date = selection

        switch displayedComponents {
        case .hourAndMinute:
            picker.datePickerMode = .time
        case .date:
            picker.datePickerMode = .date
        case [.hourAndMinute, .date]:
            picker.datePickerMode = .dateAndTime
        default:
            break
        }
    }

    class Coordinator {
        let datePicker: MyDatePicker
        init(_ datePicker: MyDatePicker) {
            self.datePicker = datePicker
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            datePicker.selection = sender.date
        }
    }
}

struct DatePickerDemo: View {
    @State var wakeUp: Date = Date()
    @State var minterval: Int = 1

    var body: some View {
        VStack {
            MyDatePicker(selection: $wakeUp, minuteInterval: 1, displayedComponents: .hourAndMinute)
        }
    }
}

struct DatePickerDemo_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerDemo()
    }
}
