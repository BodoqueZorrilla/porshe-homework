//
//  PhotoDetailTests.swift
//  PorscheHWTests
//
//  Created by Sergio Eduardo Zorilla Arellano on 19/10/23.
//

import Foundation
import XCTest
@testable import PorscheHW

final class PhotoDetailTests: XCTestCase {
    
    private var sut: PhotoDetailViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PhotoDetailViewModel(idPhoto: "33")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_FetchData() async throws {
        await sut.fetchImageData()
        XCTAssertNotNil(sut.photoData)
    }
}
