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
        XCTAssertNotNil(sut.topics)
        XCTAssertTrue(sut.topics?.count ?? 0 > 0)
    }

    func test_FetchImage() async throws {
        await sut.loadLuckyImage()
        XCTAssertNotNil(sut.lucky)
    }
}
