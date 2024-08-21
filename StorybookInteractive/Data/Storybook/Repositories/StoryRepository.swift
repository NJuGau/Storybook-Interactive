//
//  StoryRepository.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol StoryRepository {
    func fetchListStory() -> ([Story], ErrorHandler?)
    func fetchStoryByBookIdAndPage(req: StoryRequest) -> ([Story], ErrorHandler?)
}

internal final class JSONStoryRepository: StoryRepository {
    private let jsonManager = JsonManager.shared
    
    func fetchListStory() -> ([Story], ErrorHandler?) {
        let result = jsonManager.loadJSONData(from: "Story", as: [Story].self)
        
        switch result {
        case .success(let stories):
            return (stories, nil)
        case .failure(let error):
            return ([], error)
        }
    }
    
    func fetchStoryByBookIdAndPage(req: StoryRequest) -> ([Story], ErrorHandler?) {
        let (stories, errorHandler) = fetchListStory()
        
        if let error = errorHandler {
            return ([], error)
        }

        let result = stories.filter{
            $0.bookId == req.bookId &&
            $0.page == req.page
        }
        
        return (result, nil)
    }
}
