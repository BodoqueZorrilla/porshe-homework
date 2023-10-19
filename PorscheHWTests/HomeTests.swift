//
//  HomeTests.swift
//  PorscheHWTests
//
//  Created by Sergio Eduardo Zorilla Arellano on 18/10/23.
//

import XCTest
@testable import PorscheHW

final class HomeTests: XCTestCase {
    
    private var sut: HomeViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HomeViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_FetchData() async throws {
        await sut.fetchMainImages()
        if let url = Bundle.main.url(forResource: "home", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([TopicsModel].self, from: data)
                XCTAssertNotNil(jsonData)
                XCTAssertEqual(sut.topics?.count, 1)
            } catch {
                XCTFail("Error info: \(error)")
            }
        }
        
    }
}
