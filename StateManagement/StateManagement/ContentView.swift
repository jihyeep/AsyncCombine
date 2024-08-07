//
//  ContentView.swift
//  StateManagement
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

class Counter: ObservableObject {
    @Published var count = 0
}

struct StateStepper: View {
    @StateObject var stateCounter = Counter()
//    @ObservedObject var stateCounter = Counter() /// count의 상태를 잃어버림
    
    var body: some View {
        Section(header: Text("@StateObject")) {
            Stepper("Counter: \(stateCounter.count)", value: $stateCounter.count)
        }
    }
}

struct ContentView: View {
    @State var color: Color = Color.accentColor
    
    var body: some View {
        VStack(alignment: .leading) {
            StateStepper()
            ColorPicker("Pick a color", selection: $color)
        }
        .foregroundStyle(color)
    }
}

#Preview {
    ContentView()
}
