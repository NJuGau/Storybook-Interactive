//
//  BookUsecase.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol BookUsecaseProtocol {
    func fetchListBook() -> ([Book], ErrorHandler?)
}

internal final class BookUsecase: BookUsecaseProtocol {
    private let bookRepository: BookRepository
    
    init(bookRepository: BookRepository) {
        self.bookRepository = bookRepository
    }

    func fetchListBook() -> ([Book], ErrorHandler?) {
        bookRepository.fetchListBook()
    }
}
