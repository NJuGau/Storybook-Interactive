//
//  StoryScanRepository.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 21/08/24.
//

import Foundation

internal protocol StoryScanRepository {
    func fetchListScanCard() -> ([StoryScan], ErrorHandler?)
    func fetchScanCardByBookIdAndPage(req: StoryScanRequest) -> ([StoryScan], ErrorHandler?)
}

internal final class JSONStoryScanRepository: StoryScanRepository {
    private let jsonManager = JsonManager.shared
    
    func fetchListScanCard() -> ([StoryScan], ErrorHandler?) {
        
        let result = jsonManager.loadJSONData(from: "StoryScan", as: [StoryScan].self)
        
        switch result {
        case .success(let scanCards):
            return (scanCards, nil)
        case .failure(let error):
            return ([], error)
        }
    }
    
    func fetchScanCardByBookIdAndPage(req: StoryScanRequest) -> ([StoryScan], ErrorHandler?) {
        
        let (scanCards, errorHandler) = fetchListScanCard()
        
        if let error = errorHandler {
            return ([], error)
        }

        let result = scanCards.filter{
            $0.bookId == req.bookId &&
            $0.page == req.page
        }
        
        return (result, nil)
    }
}
