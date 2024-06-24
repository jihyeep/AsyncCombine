//
//  LibraryViewModel.swift
//  WordBrowser
//
//  Created by 박지혜 on 6/24/24.
//

import Foundation

class LibraryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var randomWord = "partially"
    @Published var tips: [String] = ["Swift", "authentication", "authorization"]
    @Published var favorites: [String] = ["stunning", "brilliant", "marvelous"]
    @Published var filteredTips = [String]()
    @Published var filteredFavorites = [String]()
}
