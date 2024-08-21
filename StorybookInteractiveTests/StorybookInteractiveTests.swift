//
//  StorybookInteractiveTests.swift
//  StorybookInteractiveTests
//
//  Created by Nathanael Juan Gauthama on 13/08/24.
//

import XCTest
@testable import StorybookInteractive

final class StorybookInteractiveTests: XCTestCase {

    private var bookUsecase: BookUsecase!
    private var storyUsecase: StoryUsecase!
    private var backgroundUsecase: BackgroundUsecase!
    private var objectImageUsecase: ObjectImageUsecase!
    
    private var bookRepository: BookRepository!
    private var storyRepository: StoryRepository!
    private var backgroundRepository: BackgroundRepository!
    private var objectImageRepository: ObjectImageRepository!
    
    
    override func setUp() {
        super.setUp()
        bookRepository = JSONBookRepository()
        storyRepository = JSONStoryRepository()
        backgroundRepository = JSONBackgroundRepository()
        objectImageRepository = JSONObjectImageRepository()
        
        bookUsecase = BookUsecase(bookRepository: bookRepository)
        storyUsecase = StoryUsecase(storyRepository: storyRepository)
        backgroundUsecase = BackgroundUsecase(backgroundRepository: backgroundRepository)
        objectImageUsecase = ObjectImageUsecase(objectImageRepository: objectImageRepository)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchListBook() async throws {
        let fileManager = FileManager.default
        if let filePath = Bundle.main.path(forResource: "Story", ofType: "json") {
            if !fileManager.fileExists(atPath: filePath) {
               XCTFail("Story.json does not exist")
                return
            }
        } else {
            XCTFail("path to JSON file is not found")
            return
        }
        
        let bookList = bookUsecase.fetchListBook()
        
        XCTAssertFalse(bookList.0.isEmpty, "BookList returns an empty array")
    }
    
    func testFetchBookById() async throws {
        let fileManager = FileManager.default
        if let filePath = Bundle.main.path(forResource: "Story", ofType: "json") {
            if !fileManager.fileExists(atPath: filePath) {
               XCTFail("Story.json does not exist")
                return
            }
        } else {
            XCTFail("path to JSON file is not found")
            return
        }
        
        let book = bookUsecase.fetchBookById(req: BookRequest(id: "37bff686-7d09-4e53-aa90-fb465da131b5"))
        
        XCTAssert((book.0 != nil), "Book returns an empty array")
    }
}
