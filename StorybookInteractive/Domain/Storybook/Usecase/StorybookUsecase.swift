//
//  Storybook.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import Combine
import UIKit

internal protocol StorybookUsecaseProtocol {
    func fetchListBook() -> ([Book], ErrorHandler?)
    func fetchBookById(id: Int) -> (Book?, ErrorHandler?)
    func fetchStoryByBookId(bookId: Int, storyId: Int) -> ([StoryPage], ErrorHandler?)
}

internal final class StorybookUsecase: StorybookUsecaseProtocol {
    private let storyRepository: StorybookRepository
    
    
    init(storyRepository: StorybookRepository) {
        self.storyRepository = storyRepository
    }

    func fetchListBook() -> ([Book], ErrorHandler?) {
        storyRepository.fetchListBook()
    }
    
    func fetchBookById(id: Int) -> (Book?, ErrorHandler?) {
        storyRepository.fetchBookById(id: id)
    }
    
    func fetchStoryByBookId(bookId: Int, storyId: Int) -> ([StoryPage], ErrorHandler?) {
        storyRepository.fetchStoryByBookId(bookId: bookId, storyId: storyId)
    }
}

