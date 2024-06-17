//
//  BooksListView.swift
//  ListView
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI

private class BooksViewModel: ObservableObject {
    @Published var books: [Book] = [Book]()
    @Published var fetching = false

    @MainActor
    func fetchData() async {
        fetching = true
        do {
            /// MainActor와 await을 같이 쓰는 건 좋지 않음
            try await Task.sleep(for: .seconds(2))
        } catch {}
        
        books = Book.samples
        fetching = false
    }
}

struct BooksListView: View {
    @StateObject fileprivate var viewModel = BooksViewModel()
    
    var body: some View {
        List(viewModel.books) { book in
            BookRowView(book: book)
        }
        .overlay {
            if viewModel.fetching {
                ProgressView("Fetching data, please wait...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .animation(.default, value: viewModel.books)
        .task {
            await viewModel.fetchData()
        }
    }
}

private struct BookRowView: View {
  var book: Book
  
  var body: some View {
    HStack(alignment: .top) {
      Image(book.mediumCoverImageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 90)
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text("by \(book.author)")
          .font(.subheadline)
        Text("\(book.pages) pages")
          .font(.subheadline)
      }
      Spacer()
    }
  }
}

#Preview {
    BooksListView()
}
