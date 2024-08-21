//
//  BookRepository.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol BookRepository {
    func fetchListBook() -> ([Book], ErrorHandler?)
}

internal final class JSONBookRepository: BookRepository {
    private let jsonManager = JsonManager.shared
    
    func fetchListBook() -> ([Book], ErrorHandler?) {
        let result = jsonManager.loadJSONData(from: "Book", as: [Book].self)
        
        switch result {
        case .success(let books):
            return (books, nil)
        case .failure(let error):
            return ([], error)
        }
    }
}
