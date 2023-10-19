//
//  SectionDetailTests.swift
//  PorscheHWTests
//
//  Created by Sergio Eduardo Zorilla Arellano on 19/10/23.
//

import XCTest
@testable import PorscheHW

final class SectionDetailTests: XCTestCase {
    
    private var sut: SectionDetailViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SectionDetailViewModel(title: "some", idCollection: "myTitle")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_FetchData() async throws {
        await sut.fetchCollectionImages()
        XCTAssertNotNil(sut.collectionDetail)
        XCTAssertTrue(sut.collectionDetail?.count ?? 0 > 0)
    }

    func test_FetchPageData() async throws {
        await sut.addMoreImages(page: 3)
        XCTAssertNotNil(sut.collectionDetail)
        XCTAssertTrue(sut.collectionDetail?.count ?? 0 > 12)
    }
}

