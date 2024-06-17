//
//  Book.swift
//  BookShelf
//
//  Created by 박지혜 on 6/17/24.
//

import Foundation

struct Book: Identifiable {
    var id: String { return isbn }
    var title: String
    var author: String
    var isbn: String /// 도서관리 번호
    var pages: Int
    var isRead: Bool = false
}

extension Book {
    var smallCoverImageName: String { return "\(isbn)-S"}
    var mediumCoverImageName: String { return "\(isbn)-M"}
    var largeCoverImageName: String { return "\(isbn)-L"}
}

extension Book {
    static let sampleBooks = [
        Book(title: "Changer", author: "Matt Gemmell", isbn: "9781916265202", pages: 476),
        Book(title: "SwiftUI for Absolute Beginners", author: "Jayant Varma", isbn: "9781484255155", pages: 200),
        Book(title: "Asynchronous Programming with SwiftUI and Combine", author: "Peter Friese", isbn: "9781484285718", pages: 367),
        Book(title: "Modern Concurrency on Apple Platforms", author: "Andy Ibanez", isbn: "9781484286944", pages: 368)
    ]
}
