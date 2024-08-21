//
//  StoryScanUsecase.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 21/08/24.
//

import Foundation

internal protocol StoryScanUsecaseProtocol {
    func fetchScanCardByBookIdAndPage(req: StoryScanRequest) -> (StoryScan, ErrorHandler?)
}

internal final class StoryScanUsecase: StoryScanUsecaseProtocol {
    private let storyScanRepository: StoryScanRepository
    
    init(storyScanRepository: StoryScanRepository) {
        self.storyScanRepository = storyScanRepository
    }
    
    func fetchScanCardByBookIdAndPage(req: StoryScanRequest) -> (StoryScan, ErrorHandler?) {
        let (scanCards, errorHandler) = storyScanRepository.fetchScanCardByBookIdAndPage(req: req)
        
        let scanResult = scanCards.first ?? StoryScan(id: "", bookId: "", page: -1, scanCard: "")
        
        return (scanResult, errorHandler)
    }
}
