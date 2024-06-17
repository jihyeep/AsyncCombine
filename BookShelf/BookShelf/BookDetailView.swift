//
//  BookDetailView.swift
//  BookShelf
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    /// constant: 바인딩 전달
    BookDetailView(book: .constant(Book(title: "test", author: "test", isbn: "test", pages: 0)))
}
