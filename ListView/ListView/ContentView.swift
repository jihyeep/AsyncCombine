//
//  ContentView.swift
//  ListView
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    @State var number: Int = 42
    @State var degrees: Double = 37.5
    @State var toggle = true
    @State var name = "Peter"
    @State var secret = "s3cr3t!"
    var fruits = ["Apples", "Bananas", "Mangoes"]
    
    @State var fruit = "Mangoes"
    var body: some View {
        List {
            Text("Hello, world!")
            Label("The answer", systemImage: "42.circle")
            Slider(value: $degrees, in: 0...50) {
                Text("\(degrees)")
            } minimumValueLabel: {
                Text("min")
            } maximumValueLabel: {
                Text("max")
            }
            Stepper(value: $number, in: 0...100) {
                Text("\(number)")
            }
            Toggle(isOn: $toggle) {
                Text("Checked")
            }
            TextField("Name", text: $name)
            SecureField("Secret", text: $secret)
            ProgressView(value: 0.3)
            Picker(selection: $fruit, label: Text("Pick your favourite fruit")) {
                ForEach(fruits, id: \.self) { fruit in
                    Text(fruit)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
