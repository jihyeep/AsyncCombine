//
//  BookEditView.swift
//  BookShelf
//
//  Created by 박지혜 on 6/18/24.
//

import SwiftUI

func checkISBN(isbn: String) -> Bool {
  guard !isbn.isEmpty else {
    return false
  }
  
  let sum = isbn
    .compactMap { $0.wholeNumberValue }
    .enumerated()
    .map { $0.offset & 1 == 1 ? 3 * $0.element : $0.element }
    .reduce(0, +)
  
  return sum % 10 == 0
}

class BookEditViewModel: ObservableObject {
    @Published var book: Book
    var isISBNValid: Bool {
        checkISBN(isbn: book.isbn)
    }
    
    init(book: Book) {
        self.book = book
    }
}

struct BookEditView: View {
    @ObservedObject var bookEditViewModel: BookEditViewModel
    
    init(book: Book) {
        self.bookEditViewModel = BookEditViewModel(book: book)
    }
    
    var body: some View {
        Form {
            TextField("Book title", text: $bookEditViewModel.book.title)
            Image(bookEditViewModel.book.largeCoverImageName)
            TextField("Author", text: $bookEditViewModel.book.author)
            VStack(alignment: .leading) {
                if !bookEditViewModel.isISBNValid {
                    Text("ISBN is invalid")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                TextField("ISBN", text: $bookEditViewModel.book.isbn)
            }
            TextField("Pages", value: $bookEditViewModel.book.pages, formatter: NumberFormatter())
            Toggle("Read", isOn: $bookEditViewModel.book.isRead)
        }
        .onChange(of: bookEditViewModel.book.isbn) {
            print("TEST \(bookEditViewModel.isISBNValid)")
            print("isbn: \(bookEditViewModel.book.isbn)")
        }
    }
}

#Preview {
    BookEditView(book: Book.sampleBooks[0])
}
