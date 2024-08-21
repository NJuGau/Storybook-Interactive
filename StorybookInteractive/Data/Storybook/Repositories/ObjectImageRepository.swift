//
//  ObjectImageRepository.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol ObjectImageRepository {
    func fetchListObjectImage() -> ([ObjectImage], ErrorHandler?)
    func fetchObjectImageByBookIdAndPage(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?)
    func fetchObjectImageByBookIdPageAndScanable(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?)
}

internal final class JSONObjectImageRepository: ObjectImageRepository {
    
    private let jsonManager = JsonManager.shared

    func fetchListObjectImage() -> ([ObjectImage], ErrorHandler?) {
        let result = jsonManager.loadJSONData(from: "ObjectImage", as: [ObjectImage].self)
        
        switch result {
        case .success(let images):
            return (images, nil)
        case .failure(let error):
            return ([], error)
        }
    }
    
    func fetchObjectImageByBookIdAndPage(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?) {
        let (images, errorHandler) = fetchListObjectImage()
        
        if let error = errorHandler {
            return ([], error)
        }

        let result = images.filter{
            $0.bookId == req.bookId &&
            $0.page == req.page
        }
        
        return (result, nil)
    }
    
    func fetchObjectImageByBookIdPageAndScanable(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?) {
        let (images, errorHandler) = fetchObjectImageByBookIdAndPage(req: req)
        
        if let error = errorHandler {
            return ([], error)
        }
        
        let result = images.filter{
            $0.isScan == req.isScan
        }
        
        return (result, nil)
    }
}
