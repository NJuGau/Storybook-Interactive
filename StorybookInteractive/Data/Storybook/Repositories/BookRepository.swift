//
//  BookRepository.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol BookRepository {
    func fetchListBook() -> ([Book], ErrorHandler?)
    func fetchBookById(req: BookRequest) -> (Book?, ErrorHandler?)
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
    
    func fetchBookById(req: BookRequest) -> (Book?, ErrorHandler?) {
        let (books, errorHandler) = fetchListBook()
        
        if let error = errorHandler {
            return (nil, error)
        }

        let result = books.first{
            $0.id == req.id
        }
        
        return (result, nil)
    }
}
