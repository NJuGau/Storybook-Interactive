//
//  BackgroundRepository.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol BackgroundRepository {
    func fetchListBackground() -> ([Background], ErrorHandler?)
    func fetchBackgorundByBookIdAndPage(req: BackgroundRequest) -> ([Background], ErrorHandler?)
}

internal final class JSONBackgroundRepository: BackgroundRepository {
    private let jsonManager = JsonManager.shared

    func fetchListBackground() -> ([Background], ErrorHandler?) {
        let result = jsonManager.loadJSONData(from: "Background", as: [Background].self)
        
        switch result {
        case .success(let backgrounds):
            return (backgrounds, nil)
        case .failure(let error):
            return ([], error)
        }
    }
    
    func fetchBackgorundByBookIdAndPage(req: BackgroundRequest) -> ([Background], ErrorHandler?) {
        let (backgrounds, errorHandler) = fetchListBackground()
        
        if let error = errorHandler {
            return ([], error)
        }

        let result = backgrounds.filter{
            $0.bookId == req.bookId &&
            $0.page == req.page
        }
        
        return (result, nil)
    }
}
