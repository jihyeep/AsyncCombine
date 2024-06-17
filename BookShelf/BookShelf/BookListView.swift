//
//  ContentView.swift
//  BookShelf
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

/// ViewModel
class BooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.sampleBooks
}

struct BookListView: View {
    @StateObject var booksViewModel = BooksViewModel()
    
    var body: some View {
        NavigationStack {
            List(booksViewModel.books) { book in
                BookRowView(book: book)
            }
            .listStyle(.plain)
            .navigationTitle("Books")
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BookListView()
}

