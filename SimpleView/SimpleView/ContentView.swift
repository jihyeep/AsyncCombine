//
//  ContentView.swift
//  SimpleView
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

/// ViewModel
private class PersonViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    
    func save() {
        print("Save to disk")
    }
}

struct ContentView: View {
    @State var message = ""
    @State var dirty = false
    @StateObject private var viewModel = PersonViewModel()
    
    var body: some View {
        Form {
            Section("\(self.dirty ? "*" : "")Input fields") {
                TextField("First Name", text: $viewModel.firstName)
                    .onChange(of: viewModel.firstName) {
                        self.dirty = true
                    }
                TextField("Last Name", text: $viewModel.lastName)
                    .onChange(of: viewModel.firstName) {
                        self.dirty = true
                    }
            }
            .onSubmit {
                viewModel.save()
                self.dirty = false
            }
        }
    }
}

#Preview {
    ContentView()
}
