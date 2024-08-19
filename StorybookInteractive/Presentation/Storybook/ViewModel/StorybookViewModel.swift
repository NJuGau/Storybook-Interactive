//
//  StorybookViewModel.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import Combine

internal final class StorybookViewModel {
    private let useCase: StorybookUsecase
    private var bookId: Int
    private var storyId: Int
    private var textStoryId: Int
    
    init(bookId: Int, storyId: Int, textStoryId: Int, useCase: StorybookUsecase){
        self.bookId = bookId
        self.storyId = storyId
        self.textStoryId = textStoryId
        self.useCase = useCase
    }
    
    func loadData() -> [StoryPage]{
        let result = useCase.fetchStoryByBookId(bookId: bookId, storyId: storyId)
        let pages = result.0
        let errorHandler = result.1
        
        // Handle the error if needed
        if let errorHandler = errorHandler {
            print("ini error", errorHandler)
        }
        
        return pages

    }
    
}
