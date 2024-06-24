//
//  WordDetailView.swift
//  WordBrowser
//
//  Created by 박지혜 on 6/24/24.
//

import SwiftUI

struct WordDetailView: View {
    @StateObject var viewModel = WordDetailViewModel()
    @State var word: String
    
    var body: some View {
        ZStack {
            if viewModel.isSearching {
                ProgressView("Fetching...")
            } else {
                List {
                    Section("Definitions") {
                        ForEach(viewModel.definitions) { definition in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("(\(definition.partOfSpeech))")
                                        .font(.caption)
                                    Text(definition.definition)
                                }
                                Spacer()
                            }
                        }
                    }
                    .lineLimit(2)
                }
            }
        }
        .navigationTitle(word)
    }
}

#Preview {
    NavigationStack {
        WordDetailView(word: "Swift")
    }
}

