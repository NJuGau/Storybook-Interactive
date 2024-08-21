//
//  StorybookInteractiveTests.swift
//  StorybookInteractiveTests
//
//  Created by Nathanael Juan Gauthama on 13/08/24.
//

import XCTest
@testable import StorybookInteractive

final class StorybookInteractiveTests: XCTestCase {

    private var useCase: StorybookUsecase!
    private var repository: StorybookRepository!
    
    override func setUp() {
        super.setUp()
        repository = JSONStorybookRepository()
        useCase = StorybookUsecase(storyRepository: repository)
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
        
        let bookList = useCase.fetchListBook()
        
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
        
        let book = useCase.fetchBookById(id: 1)
        
        XCTAssertFalse(book.0, "Book returns an empty array")
    }
}

//
//  PukPuk_Tests.swift
//  PukPuk-Tests
//
//  Created by Muhammad Rasyad Caesarardhi on 14/08/24.
//

//@testable import PukPuk
//import XCTest
//
//final class PukPuk_Tests: XCTestCase {
//    private var useCase: HomeUseCase!
//    private var repository: HomeDefaultRepository!
//    private var dataSource: HomeLocalDataSource!
//    
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        super.setUp()
//        dataSource = HomeLocalDataSource()
//        repository = HomeDefaultRepository(homeLocalDataSource: dataSource)
//        useCase = HomeUseCase(homeRepository: repository)
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testCryClassificationIndicatesNotCry() async throws {
//        // Use a valid URL for a test file where "not_cry" is expected
//        guard let url = Bundle.main.url(forResource: "not_cry", withExtension: "wav") else {
//            XCTFail("URL for the resource is nil.")
//            return
//        }
//
//        do {
//            // Call the function that is expected to throw an error
//            let _ = try await useCase.getModelResult(url: url)
//            XCTFail("Expected error, but got response")
//        } catch let error as CryClassificationError {
//            XCTAssertEqual(error, .notCryDetected)
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//        }
//    }
//        
//    func testCryClassificationSuccess() async throws {
//        // Use a valid URL for a test file where "cry" is expected
//        guard let url = Bundle.main.url(forResource: "542c", withExtension: "wav") else {
//            XCTFail("URL for the resource is nil.")
//            return
//        }
//
//        do {
//            // Call the function to get classification results
//           
//            let results = try await useCase.getModelResult(url: url)
//                
//            // Check that results are not empty
//            XCTAssertFalse(results.isEmpty, "Results should not be empty")
//            // Additional assertions for specific results can be added here
//                
//        } catch {
//            XCTFail("Expected success, but got error: \(error)")
//        }
//    }
//}
