//
//  ShowingAllUserAlbumsViewModelTest.swift
//  camshareTests
//
//  Created by Janco Erasmus on 2020/03/09.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest
@testable import camPod
@testable import camshare

class ShowingAllUserAlbumsViewModelTest: XCTestCase {

    var systemUnderTest: ShowingAllUserAlbumsViewModel!
    override func setUp() {
        systemUnderTest = ShowingAllUserAlbumsViewModel()
    }

    func testGivenANewAlbumThenGenerateAUniqiueAlbumID() {
        let uniqueID = systemUnderTest.generateUniqueAlbumID()
        var isCreated: Bool = false
        if uniqueID.count == 25 {
            isCreated = true
        }
        XCTAssert(isCreated)
    }

    func testGivenUniqueAlbumIDExistsWhenGeneratingNewAlbumID() {
        let uniqueID = "1"
        let result = systemUnderTest.isIDUnique(generatedID: uniqueID)
        XCTAssert(result)
    }
}
