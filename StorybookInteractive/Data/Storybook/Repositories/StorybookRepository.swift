//
//  StoryRepository.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import Combine

internal protocol StorybookRepository {
    func fetchListBook() -> ([Book], ErrorHandler?)
    func fetchBookById(id: Int) -> (Book?, ErrorHandler?)
    func fetchStoryByBookId(bookId: Int, storyId: Int) -> ([StoryPage], ErrorHandler?)
}

internal final class JSONStorybookRepository: StorybookRepository {

    private let jsonManager = JsonManager.shared
    
    func fetchListBook() -> ([Book], ErrorHandler?) {
        let result = jsonManager.loadJSONData(from: "Story", as: [Book].self)
        
        switch result {
        case .success(let books):
            return (books, nil)
        case .failure(let error):
            return ([], error)
        }
    }
    
    func fetchBookById(id: Int) -> (Book?, ErrorHandler?) {
        let (books, errorHandler) = fetchListBook()
        
        if let error = errorHandler {
            return (nil, error)
        }
        
        let book = books.first { $0.id == id }
        return (book, nil)
    }

    func fetchStoryByBookId(bookId: Int, storyId: Int) -> ([StoryPage], ErrorHandler?) {
        let (book, errorHandler) = fetchBookById(id: bookId)
        
        if let error = errorHandler {
            return ([], error)
        }
        
        guard let book = book else {
            return ([], nil)
        }
        
        let storyPages = book.listStory.filter { $0.id == storyId }
        return (storyPages, nil)
    }
}

