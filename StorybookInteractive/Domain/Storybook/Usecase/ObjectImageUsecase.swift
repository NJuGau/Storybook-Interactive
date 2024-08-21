//
//  ObjectImageUsecase.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 19/08/24.
//

import Foundation

internal protocol ObjectImageUsecaseProtocol {
    func fetchObjectImageByBookIdAndPage(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?)
    func fetchObjectImageByBookIdPageAndScanable(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?)
}

internal final class ObjectImageUsecase: ObjectImageUsecaseProtocol {
    private let objectImageRepository: ObjectImageRepository
    
    init(objectImageRepository: ObjectImageRepository) {
        self.objectImageRepository = objectImageRepository
    }
    
    func fetchObjectImageByBookIdAndPage(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?) {
        return objectImageRepository.fetchObjectImageByBookIdAndPage(req: req)
    }
    
    func fetchObjectImageByBookIdPageAndScanable(req: ObjectImageRequest) -> ([ObjectImage], ErrorHandler?) {
        return objectImageRepository.fetchObjectImageByBookIdPageAndScanable(req: req)
    }
}
