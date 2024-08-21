//
//  BackgroundUsecase.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol BackgroundUsecaseProtocol {
    func fetchBackgorundByBookIdAndPage(req: BackgroundRequest) -> ([Background], ErrorHandler?)
}

internal final class BackgroundUsecase: BackgroundUsecaseProtocol {
    private let backgroundRepository: BackgroundRepository
    
    init(backgroundRepository: BackgroundRepository) {
        self.backgroundRepository = backgroundRepository
    }
        
    func fetchBackgorundByBookIdAndPage(req: BackgroundRequest) -> ([Background], ErrorHandler?) {
        return backgroundRepository.fetchBackgorundByBookIdAndPage(req: req)
    }
}
