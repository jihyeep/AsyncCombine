//
//  BooksListView.swift
//  ListView
//
//  Created by 박지혜 on 6/17/24.
//

import SwiftUI
import Combine

///
private extension String {
    func matches(_ searchTerm: String) -> Bool {
        self.range(of: searchTerm, options: .caseInsensitive) != nil
  }
}

private class BooksViewModel: ObservableObject {
    @Published var books: [Book] = Book.samples
    @Published var fetching = false
    @Published var searchTerm: String = ""
    
    @Published var filteredBooks: [Book] = [Book]()
    
    init() {
        Publishers.CombineLatest($books, $searchTerm).map { books, searchTerm in
            books.filter { book in
                searchTerm.isEmpty ? true : (book.title.matches(searchTerm) || book.author.matches(searchTerm))
            }
        }
        .assign(to: &$filteredBooks)
    }

    @MainActor
    func fetchData() async {
        fetching = true
        /// List 위로 겹쳐서 progressBar가 그려지는 문제 해결
        books.removeAll()
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
        List(viewModel.filteredBooks) { book in
            BookRowView(book: book)
        }
        /// 서치바
        .searchable(text: $viewModel.searchTerm)
        .textInputAutocapitalization(.none) ///
        /// 당겨서 화면 새로고침
        .refreshable {
            await viewModel.fetchData()
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
    NavigationStack {
        BooksListView()
    }
}
