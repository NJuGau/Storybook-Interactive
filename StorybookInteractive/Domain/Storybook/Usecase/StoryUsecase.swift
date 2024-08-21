//
//  StoryUsecase.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol StoryUsecaseProtocol {
    func fetchStoryByBookIdAndPage(req: StoryRequest) -> ([Story], ErrorHandler?)
}

internal final class StoryUsecase: StoryUsecaseProtocol {
    private let storyRepository: StoryRepository
    
    init(storyRepository: StoryRepository) {
        self.storyRepository = storyRepository
    }
    
    func fetchStoryByBookIdAndPage(req: StoryRequest) -> ([Story], ErrorHandler?) {
        return storyRepository.fetchStoryByBookIdAndPage(req: req)
    }
}
