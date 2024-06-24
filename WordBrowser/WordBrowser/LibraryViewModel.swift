//
//  LibraryViewModel.swift
//  WordBrowser
//
//  Created by 박지혜 on 6/24/24.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var randomWord = "partially"
    @Published var tips: [String] = ["Swift", "authentication", "authorization"]
    @Published var favorites: [String] = ["stunning", "brilliant", "marvelous"]
    // searchable
    @Published var filteredTips = [String]()
    @Published var filteredFavorites = [String]()
    
    init() {
        Publishers.CombineLatest($searchText, $tips).map { query, items in
            items.filter { item in
                query.isEmpty ? true : item.contains(query)
            }
        }
        .assign(to: &$filteredTips)
        
        Publishers.CombineLatest($searchText, $favorites).map { query, items in
            items.filter { item in
                query.isEmpty ? true : item.contains(query)
            }
        }
        .assign(to: &$filteredFavorites)
    }
    
    func addFavorite(_ word: String) {
        favorites.append(word)
    }
}
