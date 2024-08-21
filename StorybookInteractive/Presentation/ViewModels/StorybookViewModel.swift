//
//  StorybookViewModel.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import Combine

internal final class StorybookViewModel {
    private let storyUsecase: StoryUsecase
    private let backgroundUsecase: BackgroundUsecase
    private let objectImageUsecase: ObjectImageUsecase
    private let bookUsecase: BookUsecase
    private var bookId: String
    private var page: Int
    
    init(
        bookId: String,
        page: Int,
        bookUsecase: BookUsecase,
        storyUsecase: StoryUsecase,
        backgroundUsecase: BackgroundUsecase,
        objectImageUsecase: ObjectImageUsecase
    )
    {
        self.bookId = bookId
        self.page = page
        self.bookUsecase = bookUsecase
        self.storyUsecase = storyUsecase
        self.backgroundUsecase = backgroundUsecase
        self.objectImageUsecase = objectImageUsecase
    }
    
    func loadBookDetail() -> Book {
        let result = bookUsecase.fetchBookById(req: BookRequest(id: bookId))
        let book = result.0
        let errorHandler = result.1
        
        if let errorHandler = errorHandler {
            print("error load book detail", errorHandler)
        }

        return book!
    }
    
    // GET BACKGROUND IMAGES
    func loadBackgroundImages() -> [Background] {
        let result = backgroundUsecase.fetchBackgorundByBookIdAndPage(req: BackgroundRequest(bookId: bookId, page: page))
        let images = result.0
        let errorHandler = result.1
        
        if let errorHandler = errorHandler {
            print("error load backgorund images", errorHandler)
        }
        
        return images
    }
    
    // GET STORIES BY BOOD AND PAGE
    func loadStories() -> [Story] {
        let result = storyUsecase.fetchStoryByBookIdAndPage(req: StoryRequest(bookId: bookId, page: page))
        let stories = result.0
        let errorHandler = result.1

        if let errorHandler = errorHandler {
            print("error load stories", errorHandler)
        }

        return stories
    }
    
    // GET IMAGE
    func loadImage() -> [ObjectImage] {
        let result = objectImageUsecase.fetchObjectImageByBookIdAndPage(req: ObjectImageRequest(bookId: bookId, page: page, isScan: false))
        
        let images = result.0
        let errorHandler = result.1
        
        if let errorHandler = errorHandler {
            print("error load object image", errorHandler)
        }
        
        return images
    }
    
    // GET SCANABLE IMAGES
    func loadScanableImage() -> [ObjectImage] {
        let result = objectImageUsecase.fetchObjectImageByBookIdPageAndScanable(req: ObjectImageRequest(bookId: bookId, page: page, isScan: true))
        
        let images = result.0
        let errorHandler = result.1
        
        if let errorHandler = errorHandler {
            print("error load scanable object image", errorHandler)
        }
        
        return images
    }
}
