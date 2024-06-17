//
//  ContentView.swift
//  BookShelf
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

struct BookListView: View {
    var books: [Book] = Book.sampleBooks
    
    var body: some View {
        List(books) { book in
            BookRowView(book: book)
        }
        .listStyle(.plain)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BookListView()
}

